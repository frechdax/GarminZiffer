using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.Graphics as Graphics;
using Toybox.System as System;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.WatchUi as WatchUi;

class GarminZifferView extends WatchUi.WatchFace {
    const COLOR_BG_OUTER = 0x2A111F;
    const COLOR_BG_MID = 0x3A1C2B;
    const COLOR_BG_INNER = 0x4A2437;
    const COLOR_PANEL = 0x2A1621;
    const COLOR_PANEL_EDGE = 0x543244;

    const COLOR_TEXT = 0xFFF3F6;
    const COLOR_MUTED = 0xE6C4D0;
    const COLOR_ROSE = 0xF0A7BC;
    const COLOR_DEEP_ROSE = 0xD887A2;
    const COLOR_GOLD = 0xE5BE84;
    const COLOR_LILAC = 0xC9A9EA;
    const COLOR_TRACK = 0x684054;

    const STEP_GOAL = 10000;

    var _lowPower = false;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
    }

    function onShow() {
    }

    function onHide() {
    }

    function onEnterSleep() {
        _lowPower = true;
    }

    function onExitSleep() {
        _lowPower = false;
    }

    function onUpdate(dc) {
        var w = dc.getWidth();
        var h = dc.getHeight();
        var size = (w < h) ? w : h;
        var scale = size.toFloat() / 454.0;
        var cx = w / 2;
        var cy = h / 2;

        drawRoseBackground(dc, cx, cy, size, scale);

        if (_lowPower) {
            drawAlwaysOn(dc, cx, cy, scale);
        } else {
            drawFullFace(dc, cx, cy, scale);
        }
    }

    private function drawRoseBackground(dc, cx, cy, size, scale) {
        dc.setColor(COLOR_BG_OUTER, COLOR_BG_OUTER);
        dc.clear();

        dc.setColor(COLOR_BG_MID, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx, cy, ((size / 2) - (2 * scale)).toNumber());

        dc.setColor(COLOR_BG_INNER, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx, cy - (10 * scale).toNumber(), ((size / 2) - (20 * scale)).toNumber());

        dc.setPenWidth(2);
        dc.setColor(COLOR_PANEL_EDGE, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(cx, cy, ((size / 2) - (7 * scale)).toNumber());

        dc.setColor(COLOR_DEEP_ROSE, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(cx, cy, ((size / 2) - (15 * scale)).toNumber());

        drawMoon(dc, cx, (68 * scale).toNumber(), scale);
        drawFlorals(dc, cx, cy, scale);
        drawBottomSprig(dc, cx, cy + (166 * scale).toNumber(), scale);
    }

    private function drawMoon(dc, cx, y, scale) {
        var r = (15 * scale).toNumber();
        if (r < 9) {
            r = 9;
        }

        dc.setColor(COLOR_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx, y, r);

        dc.setColor(COLOR_BG_OUTER, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx + (6 * scale).toNumber(), y - (3 * scale).toNumber(), r);

        drawStar(dc, cx - (39 * scale).toNumber(), y + (2 * scale).toNumber(), scale, COLOR_GOLD);
        drawStar(dc, cx + (43 * scale).toNumber(), y - (7 * scale).toNumber(), scale, COLOR_ROSE);
    }

    private function drawStar(dc, x, y, scale, color) {
        var arm = (5 * scale).toNumber();
        if (arm < 3) {
            arm = 3;
        }

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
        dc.drawLine(x - arm, y, x + arm, y);
        dc.drawLine(x, y - arm, x, y + arm);
    }

    private function drawFlorals(dc, cx, cy, scale) {
        var left = cx - (155 * scale).toNumber();
        var right = cx + (155 * scale).toNumber();
        var top = cy - (96 * scale).toNumber();

        drawFlower(dc, left, top, scale, COLOR_ROSE);
        drawFlower(dc, right, top, scale, COLOR_ROSE);

        drawFlower(dc, left - (12 * scale).toNumber(), top + (35 * scale).toNumber(), scale * 0.75, COLOR_DEEP_ROSE);
        drawFlower(dc, right + (12 * scale).toNumber(), top + (35 * scale).toNumber(), scale * 0.75, COLOR_DEEP_ROSE);

        drawLeaf(dc, left - (17 * scale).toNumber(), top + (67 * scale).toNumber(), scale, COLOR_LILAC);
        drawLeaf(dc, right + (17 * scale).toNumber(), top + (67 * scale).toNumber(), scale, COLOR_LILAC);

        dc.setColor(COLOR_TRACK, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawLine(left + (3 * scale).toNumber(), top + (10 * scale).toNumber(), left - (20 * scale).toNumber(), top + (88 * scale).toNumber());
        dc.drawLine(right - (3 * scale).toNumber(), top + (10 * scale).toNumber(), right + (20 * scale).toNumber(), top + (88 * scale).toNumber());
    }

    private function drawFlower(dc, x, y, scale, color) {
        var p = (6 * scale).toNumber();
        if (p < 3) {
            p = 3;
        }

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x - p, y, p);
        dc.fillCircle(x + p, y, p);
        dc.fillCircle(x, y - p, p);
        dc.fillCircle(x, y + p, p);

        dc.setColor(COLOR_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x, y, (p / 2).toNumber());
    }

    private function drawLeaf(dc, x, y, scale, color) {
        var r = (5 * scale).toNumber();
        if (r < 3) {
            r = 3;
        }

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x - r, y, r);
        dc.fillCircle(x + r, y - r, r);
    }

    private function drawBottomSprig(dc, x, y, scale) {
        var arm = (16 * scale).toNumber();
        if (arm < 10) {
            arm = 10;
        }

        dc.setColor(COLOR_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawLine(x, y + arm, x, y);
        dc.drawLine(x, y + (arm / 2), x - arm, y);
        dc.drawLine(x, y + (arm / 2), x + arm, y);

        dc.setColor(COLOR_ROSE, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x - arm, y, 4);
        dc.setColor(COLOR_LILAC, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x + arm, y, 4);
    }

    private function drawFullFace(dc, cx, cy, scale) {
        var now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dateText = now.day.format("%02d") + "." + now.month.format("%02d") + ".";

        dc.setColor(COLOR_MUTED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, (108 * scale).toNumber(), Graphics.FONT_SMALL, dateText, Graphics.TEXT_JUSTIFY_CENTER);

        var clock = System.getClockTime();
        var hour = clock.hour;
        if (!System.getDeviceSettings().is24Hour) {
            hour = hour % 12;
            if (hour == 0) {
                hour = 12;
            }
        }

        var timeText = hour.format("%02d") + ":" + clock.min.format("%02d");

        dc.setColor(COLOR_TEXT, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, (154 * scale).toNumber(), Graphics.FONT_NUMBER_MEDIUM, timeText, Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(COLOR_ROSE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, (236 * scale).toNumber(), Graphics.FONT_XTINY, "FLEUR ROSÉ", Graphics.TEXT_JUSTIFY_CENTER);

        drawMetricSection(dc, cx, cy, scale);
    }

    private function drawMetricSection(dc, cx, cy, scale) {
        var activity = ActivityMonitor.getInfo();
        var steps = (activity.steps == null) ? 0 : activity.steps;
        var battery = System.getSystemStats().battery.toNumber();

        var goalPercent = (steps * 100) / STEP_GOAL;
        if (goalPercent > 100) {
            goalPercent = 100;
        }

        var y = cy + (113 * scale).toNumber();
        var gap = (104 * scale).toNumber();
        var radius = (39 * scale).toNumber();
        if (radius < 30) {
            radius = 30;
        }

        drawMetric(dc, cx - gap, y, radius, COLOR_ROSE, formatSteps(steps), "STEPS", safeProgress(steps, STEP_GOAL));
        drawMetric(dc, cx, y, radius, COLOR_GOLD, goalPercent.format("%d") + "%", "GOAL", safeProgress(goalPercent, 100));
        drawMetric(dc, cx + gap, y, radius, COLOR_LILAC, battery.format("%d") + "%", "BAT", safeProgress(battery, 100));
    }

    private function drawMetric(dc, x, y, radius, accent, valueText, label, progress) {
        dc.setColor(COLOR_PANEL, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x, y, radius);

        dc.setPenWidth(4);
        dc.setColor(COLOR_TRACK, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(x, y, radius, Graphics.ARC_COUNTER_CLOCKWISE, 220, -40);

        if (progress > 0.0) {
            var endAngle = 220 - (260.0 * progress);
            dc.setColor(accent, Graphics.COLOR_TRANSPARENT);
            dc.drawArc(x, y, radius, Graphics.ARC_COUNTER_CLOCKWISE, 220, endAngle.toNumber());
        }

        dc.setColor(COLOR_TEXT, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y - 10, Graphics.FONT_TINY, valueText, Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(COLOR_MUTED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y + 15, Graphics.FONT_XTINY, label, Graphics.TEXT_JUSTIFY_CENTER);
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

    private function formatSteps(steps) {
        if (steps >= 1000) {
            var whole = steps / 1000;
            var decimal = (steps % 1000) / 100;
            return whole.format("%d") + "." + decimal.format("%d") + "k";
        }

        return steps.format("%d");
    }

    private function drawAlwaysOn(dc, cx, cy, scale) {
        var clock = System.getClockTime();
        var hour = clock.hour;

        if (!System.getDeviceSettings().is24Hour) {
            hour = hour % 12;
            if (hour == 0) {
                hour = 12;
            }
        }

        var timeText = hour.format("%02d") + ":" + clock.min.format("%02d");
        var shift = ((clock.min % 5) - 2) * 2;

        dc.setColor(COLOR_TEXT, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx + shift, cy - (24 * scale).toNumber(), Graphics.FONT_MEDIUM, timeText, Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(COLOR_ROSE, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx + shift, cy + (27 * scale).toNumber(), 3);
    }
}
