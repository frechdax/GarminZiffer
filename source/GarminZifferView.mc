using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.Graphics as Graphics;
using Toybox.System as System;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.WatchUi as WatchUi;

class GarminZifferView extends WatchUi.WatchFace {
    const COLOR_BG = 0x000000;
    const COLOR_WHITE = 0xF6F2F4;
    const COLOR_GOLD = 0xF2B24D;
    const COLOR_PINK = 0xF26DA8;
    const COLOR_ROSE = 0xE995B6;
    const COLOR_LILAC = 0xB78AE6;
    const COLOR_BROWN = 0x8B5A2B;
    const COLOR_BRONZE = 0xB8742A;
    const COLOR_BEIGE = 0xE8D2B0;
    const COLOR_MUTED = 0xD8C8D1;
    const COLOR_DIM = 0x6D5865;

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

        dc.setColor(COLOR_BG, COLOR_BG);
        dc.clear();

        if (_lowPower) {
            drawAlwaysOn(dc, cx, cy, scale);
        } else {
            drawDecorRing(dc, cx, cy, scale);
            drawTopInfo(dc, cx, cy, scale);
            drawMainTime(dc, cx, cy, scale);
            drawBottomInfo(dc, cx, cy, scale);
        }
    }

    private function drawTopInfo(dc, cx, cy, scale) {
        var clock = System.getClockTime();
        var hour = clock.hour;
        var suffix = "";

        if (!System.getDeviceSettings().is24Hour) {
            suffix = hour >= 12 ? "PM" : "AM";
        }

        var activity = ActivityMonitor.getInfo();
        var steps = (activity.steps == null) ? 0 : activity.steps;
        var compactSteps = formatSteps(steps);
        var topY = cy - (57 * scale).toNumber();

        dc.setColor(COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx - (48 * scale).toNumber(), topY, Graphics.FONT_SMALL, suffix, Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(COLOR_PINK, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx, topY + (13 * scale).toNumber(), 4);

        dc.setColor(COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx + (48 * scale).toNumber(), topY, Graphics.FONT_SMALL, compactSteps, Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function drawMainTime(dc, cx, cy, scale) {
        var clock = System.getClockTime();
        var hour = clock.hour;

        if (!System.getDeviceSettings().is24Hour) {
            hour = hour % 12;
            if (hour == 0) {
                hour = 12;
            }
        }

        var hh = hour.format("%02d");
        var mm = clock.min.format("%02d");
        var y = cy - (9 * scale).toNumber();
        var gap = (49 * scale).toNumber();

        dc.setColor(COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx - gap, y, Graphics.FONT_NUMBER_MEDIUM, hh, Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(COLOR_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx + gap, y, Graphics.FONT_NUMBER_MEDIUM, mm, Graphics.TEXT_JUSTIFY_CENTER);
    }

    private function drawBottomInfo(dc, cx, cy, scale) {
        var now = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var dateText = now.day.format("%02d") + "." + now.month.format("%02d");
        var battery = System.getSystemStats().battery.toNumber();
        var activity = ActivityMonitor.getInfo();
        var steps = (activity.steps == null) ? 0 : activity.steps;
        var goalPercent = (steps * 100) / STEP_GOAL;

        if (goalPercent > 100) {
            goalPercent = 100;
        }

        var row1 = cy + (53 * scale).toNumber();
        var row2 = cy + (82 * scale).toNumber();

        dc.setColor(COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx - (58 * scale).toNumber(), row1, Graphics.FONT_SMALL, dateText, Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(COLOR_MUTED, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx, row1 + (13 * scale).toNumber(), 2);

        dc.setColor(COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx + (58 * scale).toNumber(), row1, Graphics.FONT_SMALL, battery.format("%d") + "%", Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(COLOR_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, row2, Graphics.FONT_XTINY, "GOAL " + goalPercent.format("%d") + "%", Graphics.TEXT_JUSTIFY_CENTER);
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

        dc.setColor(COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(cx, cy - (20 * scale).toNumber(), Graphics.FONT_MEDIUM, timeText, Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(COLOR_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx, cy + (26 * scale).toNumber(), 3);
    }

    private function drawDecorRing(dc, cx, cy, scale) {
        drawPumpkin(dc, cx - (96 * scale).toNumber(), cy - (91 * scale).toNumber(), scale);

        drawFlower(dc, cx - (20 * scale).toNumber(), cy - (112 * scale).toNumber(), scale, COLOR_PINK, COLOR_BEIGE);
        drawBud(dc, cx + (12 * scale).toNumber(), cy - (115 * scale).toNumber(), scale, COLOR_PINK);
        drawFlower(dc, cx + (54 * scale).toNumber(), cy - (103 * scale).toNumber(), scale * 0.9, COLOR_GOLD, COLOR_BEIGE);

        drawStem(dc, cx + (92 * scale).toNumber(), cy - (94 * scale).toNumber(), scale, COLOR_BRONZE);
        drawStem(dc, cx - (116 * scale).toNumber(), cy - (58 * scale).toNumber(), scale, COLOR_PINK);

        drawLeaf(dc, cx - (126 * scale).toNumber(), cy - (12 * scale).toNumber(), scale, COLOR_PINK, true);
        drawLeaf(dc, cx - (104 * scale).toNumber(), cy + (41 * scale).toNumber(), scale, COLOR_BRONZE, false);
        drawLeaf(dc, cx - (62 * scale).toNumber(), cy + (105 * scale).toNumber(), scale, COLOR_PINK, false);

        drawLeaf(dc, cx + (118 * scale).toNumber(), cy - (45 * scale).toNumber(), scale, COLOR_BRONZE, true);
        drawLeaf(dc, cx + (122 * scale).toNumber(), cy + (2 * scale).toNumber(), scale, COLOR_BEIGE, false);
        drawLeaf(dc, cx + (84 * scale).toNumber(), cy + (66 * scale).toNumber(), scale, COLOR_DIM, true);
        drawLeaf(dc, cx + (52 * scale).toNumber(), cy + (105 * scale).toNumber(), scale, COLOR_PINK, false);

        drawFlower(dc, cx + (10 * scale).toNumber(), cy + (119 * scale).toNumber(), scale * 0.85, COLOR_PINK, COLOR_BEIGE);
        drawFlower(dc, cx - (12 * scale).toNumber(), cy + (123 * scale).toNumber(), scale * 0.65, COLOR_ROSE, COLOR_BEIGE);

        drawStar(dc, cx - (46 * scale).toNumber(), cy - (121 * scale).toNumber(), scale, COLOR_GOLD);
        drawStar(dc, cx - (132 * scale).toNumber(), cy + (10 * scale).toNumber(), scale, COLOR_BRONZE);
        drawStar(dc, cx + (132 * scale).toNumber(), cy + (58 * scale).toNumber(), scale, COLOR_GOLD);
        drawStar(dc, cx - (127 * scale).toNumber(), cy + (78 * scale).toNumber(), scale, COLOR_BRONZE);
    }

    private function drawPumpkin(dc, x, y, scale) {
        var r = (12 * scale).toNumber();
        var dx = (9 * scale).toNumber();

        if (r < 7) {
            r = 7;
        }

        dc.setColor(COLOR_BRONZE, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x - dx, y, r);
        dc.fillCircle(x, y, r + 2);
        dc.fillCircle(x + dx, y, r);

        dc.setColor(COLOR_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
        dc.drawLine(x - dx, y - r + 2, x - dx, y + r - 2);
        dc.drawLine(x + dx, y - r + 2, x + dx, y + r - 2);

        dc.setColor(COLOR_BROWN, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawLine(x, y - r - 1, x + (3 * scale).toNumber(), y - r - (10 * scale).toNumber());
    }

    private function drawFlower(dc, x, y, scale, petalColor, centerColor) {
        var p = (6 * scale).toNumber();
        if (p < 3) {
            p = 3;
        }

        dc.setColor(petalColor, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x - p, y, p);
        dc.fillCircle(x + p, y, p);
        dc.fillCircle(x, y - p, p);
        dc.fillCircle(x, y + p, p);

        dc.setColor(centerColor, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x, y, (p / 2).toNumber());
    }

    private function drawBud(dc, x, y, scale, color) {
        var r = (6 * scale).toNumber();
        if (r < 3) {
            r = 3;
        }

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(x, y, r);
        dc.fillCircle(x - r + 1, y + (4 * scale).toNumber(), r - 1);
        dc.fillCircle(x + r - 1, y + (4 * scale).toNumber(), r - 1);
    }

    private function drawLeaf(dc, x, y, scale, color, vertical) {
        var r = (7 * scale).toNumber();
        if (r < 4) {
            r = 4;
        }

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);

        if (vertical) {
            dc.fillCircle(x, y - r, r);
            dc.fillCircle(x, y + r, r);
        } else {
            dc.fillCircle(x - r, y, r);
            dc.fillCircle(x + r, y, r);
        }
    }

    private function drawStem(dc, x, y, scale, color) {
        var len = (38 * scale).toNumber();
        var leaf = (7 * scale).toNumber();

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawLine(x, y, x, y + len);
        dc.drawLine(x, y + (10 * scale).toNumber(), x - leaf, y + (4 * scale).toNumber());
        dc.drawLine(x, y + (21 * scale).toNumber(), x + leaf, y + (14 * scale).toNumber());
        dc.drawLine(x, y + (31 * scale).toNumber(), x - leaf, y + (24 * scale).toNumber());
    }

    private function drawStar(dc, x, y, scale, color) {
        var arm = (4 * scale).toNumber();
        if (arm < 3) {
            arm = 3;
        }

        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(1);
        dc.drawLine(x - arm, y, x + arm, y);
        dc.drawLine(x, y - arm, x, y + arm);
    }

    private function formatSteps(steps) {
        if (steps >= 1000) {
            var whole = steps / 1000;
            var decimal = (steps % 1000) / 100;
            return whole.format("%d") + "." + decimal.format("%d") + "k";
        }

        return steps.format("%d");
    }
}
