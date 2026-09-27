using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.Graphics as Graphics;
using Toybox.SensorHistory as SensorHistory;
using Toybox.System as System;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.WatchUi as WatchUi;

class GarminZifferView extends WatchUi.WatchFace {
    const COLOR_BG = 0x09070A;
    const COLOR_TEXT = 0xF8E9E1;
    const COLOR_PINK = 0xF3A7B8;
    const COLOR_ROSE = 0xD7899C;
    const COLOR_GOLD = 0xE0B277;
    const COLOR_LILAC = 0xC6A1DB;
    const COLOR_MUTED = 0x765F70;
    const COLOR_TRACK = 0x2B222B;

    var _lowPower = false;
    var _lastMetricMinute = -1;
    var _steps = 0;
    var _stepGoal = 10000;
    var _heartRate = -1;
    var _battery = 0;
    var _bodyBattery = -1;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
    }

    function onShow() {
        _lastMetricMinute = -1;
    }

    function onHide() {
    }

    function onEnterSleep() {
        _lowPower = true;
    }

    function onExitSleep() {
        _lowPower = false;
        _lastMetricMinute = -1;
    }

    function onUpdate(dc) {
        dc.setColor(COLOR_BG, COLOR_BG);
        dc.clear();

        if (_lowPower) {
            drawAlwaysOn(dc);
        } else {
            drawFullFace(dc);
        }
    }

    private function drawFullFace(dc) {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var cx = w / 2;
        var cy = h / 2;
        var scale = w.toFloat() / 454.0;

        drawOuterAccents(dc, cx, cy, scale);
        drawMoon(dc, cx, scale);
        drawFlorals(dc, w, scale);

        var now = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateText = now.day.format("%02d") + "." + now.month.format("%02d") + ".";
        dc.setColor(COLOR_TEXT, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, (112 * scale).toNumber(), Graphics.FONT_SMALL, dateText, Graphics.TEXT_JUSTIFY_CENTER);

        var clock = System.getClockTime();
        var hour = clock.hour;
        if (!System.getDeviceSettings().is24Hour) {
            hour = hour % 12;
            if (hour == 0) {
                hour = 12;
            }
        }

        var timeText = hour.format("%02d") + ":" + clock.min.format("%02d");
        var timeFont = (w >= 430) ? Graphics.FONT_NUMBER_MEDIUM : Graphics.FONT_NUMBER_MILD;
        dc.drawText(cx, (150 * scale).toNumber(), timeFont, timeText, Graphics.TEXT_JUSTIFY_CENTER);

        refreshMetrics(clock.min);

        var metricY = (326 * scale).toNumber();
        var radius = (38 * scale).toNumber();
        if (radius < 28) {
            radius = 28;
        }

        drawMetric(dc, (w * 0.15).toNumber(), metricY, radius, _steps, "STEPS", COLOR_PINK, safeProgress(_steps, _stepGoal), 0);
        drawMetric(dc, (w * 0.385).toNumber(), metricY, radius, _heartRate, "BPM", COLOR_ROSE, safeProgress(_heartRate, 180), 1);
        drawMetric(dc, (w * 0.615).toNumber(), metricY, radius, _battery, "BAT", COLOR_GOLD, safeProgress(_battery, 100), 2);
        drawMetric(dc, (w * 0.85).toNumber(), metricY, radius, _bodyBattery, "BODY", COLOR_LILAC, safeProgress(_bodyBattery, 100), 3);

        drawBottomSprig(dc, cx, (410 * scale).toNumber(), scale);
    }

    private function drawAlwaysOn(dc) {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var clock = System.getClockTime();
        var hour = clock.hour;

        if (!System.getDeviceSettings().is24Hour) {
            hour = hour % 12;
            if (hour == 0) {
                hour = 12;
            }
        }

        var shift = ((clock.min % 5) - 2) * 2;
        var timeText = hour.format("%02d") + ":" + clock.min.format("%02d");

        dc.setColor(COLOR_TEXT, Graphics.COLOR_TRANSPARENT);
        dc.drawText((w / 2) + shift, (h / 2) - 26, Graphics.FONT_MEDIUM, timeText, Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(COLOR_ROSE, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle((w / 2) + shift, (h / 2) + 28, 2);
    }

    private function refreshMetrics(minute) {
        if (_lastMetricMinute == minute) {
            return;
        }

        _lastMetricMinute = minute;

        var activity = ActivityMonitor.getInfo();
        _steps = (activity.steps == null) ? 0 : activity.steps;
        _stepGoal = (activity.stepGoal == null || activity.stepGoal <= 0) ? 10000 : activity.stepGoal;
        _battery = System.getSystemStats().battery.toNumber();
        _heartRate = latestHeartRate();
        _bodyBattery = latestBodyBattery();
    }

    private function latestHeartRate() {
        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getHeartRateHistory)) {
            var iterator = SensorHistory.getHeartRateHistory({
                :period => 1,
                :order => SensorHistory.ORDER_NEWEST_FIRST
            });

            if (iterator != null) {
                var sample = iterator.next();
                if (sample != null && sample.data != null) {
                    return sample.data.toNumber();
                }
            }
        }

        return -1;
    }

    private function latestBodyBattery() {
        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getBodyBatteryHistory)) {
            var iterator = SensorHistory.getBodyBatteryHistory({
                :period => 1,
                :order => SensorHistory.ORDER_NEWEST_FIRST
            });

            if (iterator != null) {
                var sample = iterator.next();
                if (sample != null && sample.data != null) {
                    return sample.data.toNumber();
                }
            }
        }

        return -1;
    }

    private function safeProgress(value, maximum) {
        if (value <= 0 || maximum <= 0) {
            return 0.0;
        }

        var progress = value.toFloat() / maximum.toFloat();
        if (progress > 1.0) {
            return 1.0;
        }

        return progress;
    }

    private function drawMetric(dc, x, y, radius, value, label, color, progress, iconType) {
        dc.setPenWidth(5);
        dc.setColor(COLOR_TRACK, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(x, y, radius, Graphics.ARC_COUNTER_CLOCKWISE, 215, -35);

        if (progress > 0.0) {
            dc.setColor(color, Graphics.COLOR_TRANSPARENT);
            var endAngle = 215 - (250.0 * progress);
            dc.drawArc(x, y, radius, Graphics.ARC_COUNTER_CLOCKWISE, 215, endAngle.toNumber());
        }

        drawMetricIcon(dc, x, y - (radius / 3), radius, color, iconType);

        dc.setColor(COLOR_TEXT, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y - 7, Graphics.FONT_TINY, formatValue(value, label), Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(COLOR_TEXT, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 23, Graphics.FONT_XTINY, label, Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function formatValue(value, label) {
        if (value < 0) {
            return "--";
        }

        if (label.equals("STEPS") && value >= 1000) {
            var whole = value / 1000;
            var decimal = (value % 1000) / 100;
            return whole.format("%d") + "." + decimal.format("%d") + "k";
        }

        if (label.equals("BAT")) {
            return value.format("%d") + "%";
        }

        return value.format("%d");
    }

    private function drawMetricIcon(dc, x, y, radius, color, iconType) {
        var s = radius / 6;
        if (s < 4) {
            s = 4;
        }

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);

        if (iconType == 0) {
            dc.fillCircle(x - s, y, s / 2);
            dc.fillCircle(x + s, y - s, s / 2);
        } else if (iconType == 1) {
            drawHeart(dc, x, y, s);
        } else if (iconType == 2) {
            dc.setPenWidth(2);
            dc.drawRectangle(x - s, y - (s / 2), s * 2, s);
            dc.fillRectangle(x + s, y - (s / 4), 2, s / 2);
        } else {
            dc.fillCircle(x, y - s, s / 2);
            dc.setPenWidth(2);
            dc.drawLine(x, y, x, y + s);
            dc.drawLine(x, y + (s / 2), x - s, y + s);
            dc.drawLine(x, y + (s / 2), x + s, y + s);
        }
    }

    private function drawHeart(dc, x, y, s) {
        dc.fillCircle(x - (s / 2), y, s / 2);
        dc.fillCircle(x + (s / 2), y, s / 2);

        var points = [
            [x - s, y],
            [x + s, y],
            [x, y + (s * 2)]
        ];
        dc.fillPolygon(points);
    }

    private function drawMoon(dc, cx, scale) {
        var y = (70 * scale).toNumber();
        var r = (15 * scale).toNumber();
        if (r < 9) {
            r = 9;
        }

        dc.setColor(COLOR_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx, y, r);

        dc.setColor(COLOR_BG, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx + (6 * scale).toNumber(), y - (3 * scale).toNumber(), r);

        drawStar(dc, cx - (43 * scale).toNumber(), y + 1, scale, COLOR_GOLD);
        drawStar(dc, cx + (45 * scale).toNumber(), y - 7, scale, COLOR_PINK);
    }

    private function drawStar(dc, x, y, scale, color) {
        var a = (5 * scale).toNumber();
        if (a < 3) {
            a = 3;
        }

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
        dc.drawLine(x - a, y, x + a, y);
        dc.drawLine(x, y - a, x, y + a);
    }

    private function drawOuterAccents(dc, cx, cy, scale) {
        var radius = (205 * scale).toNumber();
        dc.setPenWidth(5);

        dc.setColor(COLOR_PINK, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(cx, cy, radius, Graphics.ARC_COUNTER_CLOCKWISE, 112, 154);

        dc.setColor(COLOR_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(cx, cy, radius, Graphics.ARC_COUNTER_CLOCKWISE, 28, 69);

        dc.setColor(COLOR_LILAC, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(cx, cy, radius, Graphics.ARC_COUNTER_CLOCKWISE, 204, 244);

        dc.setColor(COLOR_ROSE, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(cx, cy, radius, Graphics.ARC_COUNTER_CLOCKWISE, 296, 336);
    }

    private function drawFlorals(dc, w, scale) {
        drawBranch(dc, (74 * scale).toNumber(), (120 * scale).toNumber(), 1, scale);
        drawBranch(dc, w - (74 * scale).toNumber(), (120 * scale).toNumber(), -1, scale);
    }

    private function drawBranch(dc, x, y, direction, scale) {
        var stem = (78 * scale).toNumber();

        dc.setColor(COLOR_MUTED, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawLine(x, y, x - (direction * 24 * scale).toNumber(), y + stem);

        drawLeaf(dc, x - (direction * 6 * scale).toNumber(), y + (22 * scale).toNumber(), direction, scale, COLOR_ROSE);
        drawLeaf(dc, x - (direction * 13 * scale).toNumber(), y + (44 * scale).toNumber(), -direction, scale, COLOR_LILAC);
        drawLeaf(dc, x - (direction * 19 * scale).toNumber(), y + (64 * scale).toNumber(), direction, scale, COLOR_ROSE);
        drawFlower(dc, x - (direction * 2 * scale).toNumber(), y + (8 * scale).toNumber(), scale);
    }

    private function drawLeaf(dc, x, y, direction, scale, color) {
        var r = (5 * scale).toNumber();
        if (r < 3) {
            r = 3;
        }

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x + (direction * r), y, r);
        dc.fillCircle(x + (direction * r * 2), y - r, r - 1);
    }

    private function drawFlower(dc, x, y, scale) {
        var p = (5 * scale).toNumber();
        if (p < 3) {
            p = 3;
        }

        dc.setColor(COLOR_PINK, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x - p, y, p);
        dc.fillCircle(x + p, y, p);
        dc.fillCircle(x, y - p, p);
        dc.fillCircle(x, y + p, p);

        dc.setColor(COLOR_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x, y, 2);
    }

    private function drawBottomSprig(dc, x, y, scale) {
        var s = (17 * scale).toNumber();
        if (s < 10) {
            s = 10;
        }

        dc.setColor(COLOR_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawLine(x, y, x, y - s);
        dc.drawLine(x, y - (s / 2), x - s, y - s);
        dc.drawLine(x, y - (s / 2), x + s, y - s);

        dc.setColor(COLOR_PINK, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x - s, y - s, 4);
        dc.setColor(COLOR_LILAC, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x + s, y - s, 4);
    }
}
