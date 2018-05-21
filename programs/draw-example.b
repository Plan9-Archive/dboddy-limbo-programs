# From the draw-example man 2 page.

implement Test;

include "sys.m";

include "draw.m";

Test: module
{
    init:    fn(ctxt: ref Draw->Context, argv: list of string);
};

init(nil: ref Draw->Context, nil: list of string)
{
    sys := load Sys Sys->PATH;
    draw := load Draw Draw->PATH;
    Display, Font, Rect, Point, Image, Screen: import draw;

    #
    # Set up connection to display and initialize colours.
    #
    display := draw->Display.allocate(nil);
    disp := display.image;
    red := display.color(Draw->Red);
    blue := display.color(Draw->Blue);
    white := display.color(Draw->White);
    yellow := display.color(Draw->Yellow);

    #
    # Paint the screen red.
    #
    disp.draw(disp.r, red, nil, disp.r.min);
    sys->sleep(5000);

    #
    # Texture a region with rectangular tiles.
    #
    texture := display.newimage(((0,0),(2,3)),
        disp.chans, 1, Draw->Black);
    texture.clipr = ((-10000,-10000),(10000,10000));
    # put something in the texture
    texture.draw(((0,0),(1,3)), white, nil, (0,0));
    texture.draw(((0,0),(2, 1)), white, nil, (0,0));
    # use texture as both source and mask to let
    # destination colour show through
    disp.draw(((100,100),(200,300)), texture,
        texture, (0,0));
    sys->sleep(5000);

    #
    # White-out a quarter of the pixels in a region,
    # to make the region appear shaded.
    #
    stipple := display.newimage(((0,0),(2,2)),
                disp.chans, 1, Draw->Transparent);
    stipple.draw(((0,0),(1,1)), display.opaque,
                nil, (0,0));
    disp.draw(((100,100),(300,250)), white,
                stipple, (0,0));
    sys->sleep(5000);

    #
    # Draw textured characters.
    #
    font := Font.open(display, "*default*");
    disp.text((100,310), texture, (0,0), font,
            "Hello world");
    sys->sleep(5000);

    #
    # Draw picture in elliptical frame.
    #
    delight := display.open("/icons/delight.bit");
    piccenter := delight.r.min.add(delight.r.max).div(2);
    disp.fillellipse((250,250), 150, 50,
        delight, piccenter);
    disp.ellipse((250,250), 150, 50, 3, yellow, (0,0));
    sys->sleep(5000);

    #
    # Draw a parabolic brush stroke using an elliptical brush
    # to reveal more of the picture, consistent with what's
    # already visible.
    #
    dx : con 15;
    dy : con 3;
    brush := display.newimage(((0,0),(2*dx+1,2*dy+1)), disp.chans,
                               0, Draw->Black);
    brush.fillellipse((dx,dy), dx, dy, display.white,
                (0,0));
    for(x:=delight.r.min.x; x<delight.r.max.x; x++){
        y := (x-piccenter.x)*(x-piccenter.x)/80;
        y += 2*dy+1;    # so whole brush is visible at top
        xx := x+(250-piccenter.x)-dx;
        yy := y+(250-piccenter.y)-dy;
        disp.gendraw(((xx,yy),(xx+2*dx+1,yy+2*dy+1)),
                       delight, (x-dx, y-dy), brush,
            (0,0));
    }
}
