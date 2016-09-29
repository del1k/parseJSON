local json = require( "json" )
local widget = require ("widget")

local filename = system.pathForFile( "images.json", system.ResourceDirectory )
local decoded, pos, msg = json.decodeFile( filename )
local actSize = 0

if not decoded then
	print ("Error "..tostring(pos)..": "..tostring(msg))
else
	print( "decoded OK")
end

local scrollView = widget.newScrollView(
    {
        top = 0,
        left = 0,
        width = display.contentWidth,
        height = display.contentHeight,
		topPadding = 0,
		bottoPadding = 0,
		horizontalScrollDisabled = false,
		verticalScrollDisabled = false
    }
)

local function networkListener( event )
    if ( event.isError ) then
        print ( "Network error - download failed", event.response )
    elseif (event.phase == "begun") then
		print ( "Progress begun")
	elseif (event.phase == "ended") then
		print ( "Progress ended")
		image = display.newImage( event.response.filename, event.response.baseDirectory, 0, 0)
		image.x = display.contentCenterX
		actSize = actSize+image.height
		image.y = actSize
		scrollView:insert(image)
    end
end

for i = 1,10,1 do
	network.download( decoded.images[i], "GET", networkListener, "image_"..tostring(i)..".png" , system.TemporaryDirectory)
end

