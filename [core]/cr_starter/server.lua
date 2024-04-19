local primaryResources = {
	"cr_mysql",
	"cr_global",
	"cr_data",
	"cr_pool",
	"cr_integration",
	"cr_vehicle",
	"cr_fonts",
	"cr_ui",
}

addEventHandler("onResourceStart", resourceRoot, function()
	for index, resource in ipairs(primaryResources) do
		startResource(getResourceFromName(resource))
	end
	
	for index, resource in ipairs(getResources()) do
		startResource(resource)
	end
end)