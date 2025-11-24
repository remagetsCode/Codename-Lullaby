
var asMX:Bool;
var asHypno:Bool;
var asLordX:Bool = true;
function postCreate(){
    modchart.setPercent('x', -100, 0);
    modchart.setPercent('x', -320, 1);
    modchart.setPercent('x', 740, 2);

    modchart.setPercent('z', asMX ? 0 : -100, 0);
    modchart.setPercent('z', asLordX ? 0 : -100, 1);
    modchart.setPercent('z', asHypno ? 0 : -100, 2);

    modchart.setPercent('alpha', asMX ? 1 : 0.4, 0);
    modchart.setPercent('alpha', asLordX ? 1 : 0.4, 1);
    modchart.setPercent('alpha', asHypno ? 1 : 0.4, 2);
}