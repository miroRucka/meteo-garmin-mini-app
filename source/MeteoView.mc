
using Toybox.WatchUi as Ui;
using Toybox.Graphics;
using Toybox.Application as App;
using Toybox.System as System;
using Toybox.Communications as Comm;
using Toybox.Time as Time;
using Toybox.Math as Math;

class MeteoView extends Ui.View {

    var statusCode = -1;


    function initialize() {
        System.println("View initialize()");
        Ui.View.initialize();
    }

    function getTemperature() {
       System.println("Querying API...");       
       var url = "https://api-s.horske.info/api/sensors/espruino_005/last";
       var options = {
         :method => Communications.HTTP_REQUEST_METHOD_GET,
         :headers => {                                           
                   	"Authorization" => "Basic c3VzbGlrOlN1c2xpazEyMw=="},
         :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON
       };
       Comm.makeWebRequest(url, null, options, method(:onReceive));
       Ui.requestUpdate();
    }
    
    function onReceive(responseCode, data) {
        System.println("Data received with code "+ responseCode.toString());
        statusCode = responseCode;
        var myapp = App.getApp();
        if (responseCode == 200) {
        	System.println("temperature 2 "+ data["temperature_t2"]);
        	myapp.setProperty("data", data);
        } 
        Ui.requestUpdate();
    }


    function onLayout(dc) {
        System.println("onLayout() called");
        System.println("Fetching data on startup");
        getTemperature();
    }


    function onShow() {
    }



    function onUpdate(dc) {
        var myapp = App.getApp();
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        
        if(statusCode == -1){
         	System.println("loading...");
         	dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        	dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_XTINY, "loading...", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        }else if(statusCode == 200){
        	dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        	dc.drawText(dc.getWidth()/2, (dc.getHeight()/2)-50, Graphics.FONT_SYSTEM_XTINY , myapp.getProperty("data")["timeFormatted"], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        	dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_NUMBER_THAI_HOT, myapp.getProperty("data")["temperature_t2"].format("%.2f"), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }else{
         	System.println("unknown status");
         	dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        	dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_XTINY, "status " + statusCode, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }

    }


    function onHide() {
    }
}
