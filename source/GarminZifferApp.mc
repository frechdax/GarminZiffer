using Toybox.Application as Application;

class GarminZifferApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
    }

    function onStop(state) {
    }

    function getInitialView() {
        return [ new GarminZifferView() ];
    }
}
