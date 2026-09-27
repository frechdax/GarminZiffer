using Toybox.ActivityMonitor as ActivityMonitor;
using Toybox.Graphics as Graphics;
using Toybox.Lang as Lang;
using Toybox.System as System;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Gregorian;
using Toybox.WatchUi as WatchUi;

class GarminZifferView extends WatchUi.WatchFace {
    var _lowPower = false;

    // Feminine palette: plum, blush and lavender.
    const COLOR_BG = 0x09070D;
    const COLOR_PANEL = 0x201522;
    const COLOR_BLUSH = 0xF2A9BE;
    const COLOR_LAVENDER = 0xB8A7F7;
    const COLOR_TEXT = 0xFFF4F7;
    const COLOR_MUTED = 0xC7AFC0;
    const COLOR_DIM = 0x6A5364;

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
    }

    function onShow() {
    }

    function onUpdate(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        var cx = width / 2;
        var cy = height / 2;

        dc.setColor(COLOR_BG, COLOR_BG);
        dc.clear();

        drawBackdrop(dc, cx, cy, width, height);
        drawTime(dc, cx, cy);

        if (!_lowPower) {
            drawDate(dc, cx, cy);
            drawStats(dc, cx, height);
            drawDecor(dc, cx, cy, width);
        }
    }

    private function drawBackdrop(dc, cx, cy, width, height) {
        if (_lowPower) {
            return;
        }

        var radius = (width < height ? width : height) / 2 - 10;
        dc.setColor(COLOR_PANEL, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx, cy, radius);

        dc.setPenWidth(3);
        dc.setColor(COLOR_BLUSH, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(cx, cy, radius - 5);
    }

    private function drawTime(dc, cx, cy) {
        var now = System.getClockTime();
        var hour = now.hour;
        var suffix = "";
        var settings = System.getDeviceSettings();

        if (!settings.is24Hour) {
            suffix = hour >= 12 ? " PM" : " AM";
            hour = hour % 12;
            if (hour == 0) {
                hour = 12;
            }
        }

        var timeText = hour.format("%02d") + ":" + now.min.format("%02d");

        dc.setColor(_lowPower ? COLOR_MUTED : COLOR_TEXT, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            cx,
            cy - 64,
            Graphics.FONT_NUMBER_MEDIUM,
            timeText,
            Graphics.TEXT_JUSTIFY_CENTER
        );

        if (!_lowPower && suffix.length() > 0) {
            dc.setColor(COLOR_LAVENDER, Graphics.COLOR_TRANSPARENT);
            dc.drawText(
                cx,
                cy + 24,
                Graphics.FONT_XTINY,
                suffix,
                Graphics.TEXT_JUSTIFY_CENTER
            );
        }
    }

    private function drawDate(dc, cx, cy) {
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateText = Lang.format("$1$ · $2$ $3$", [
            today.day_of_week,
            today.day,
            today.month
        ]);

        dc.setColor(COLOR_MUTED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            cx,
            cy + 58,
            Graphics.FONT_SMALL,
            dateText,
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    private function drawStats(dc, cx, height) {
        var activity = ActivityMonitor.getInfo();
        var steps = activity.steps;
        var battery = System.getSystemStats().battery;

        dc.setColor(COLOR_LAVENDER, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            cx,
            height - 92,
            Graphics.FONT_XTINY,
            "STEPS " + steps.format("%d"),
            Graphics.TEXT_JUSTIFY_CENTER
        );

        dc.setColor(COLOR_BLUSH, Graphics.COLOR_TRANSPARENT);
        dc.drawText(
            cx,
            height - 58,
            Graphics.FONT_XTINY,
            "BAT " + battery.format("%.0f") + "%",
            Graphics.TEXT_JUSTIFY_CENTER
        );
    }

    private function drawDecor(dc, cx, cy, width) {
        var r = width / 2 - 33;

        dc.setColor(COLOR_LAVENDER, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx - r + 8, cy - 18, 5);
        dc.fillCircle(cx + r - 8, cy - 18, 5);

        dc.setColor(COLOR_BLUSH, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(cx - r + 21, cy + 18, 3);
        dc.fillCircle(cx + r - 21, cy + 18, 3);
    }

    function onHide() {
    }

    function onEnterSleep() {
        _lowPower = true;
    }

    function onExitSleep() {
        _lowPower = false;
    }
}
