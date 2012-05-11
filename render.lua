render = {
	codeHeader = [[
extern vec3 position; // Position of the Eye
extern vec3 origin; // origin of the projection plane
extern vec3 planex;  // definition of the projection plane
extern vec3 planey;
float w = %f;     // Size of the window
float h = %f;
extern float maxIterations; // Max number of rendering step
extern float threshold;// Limit to estimate that we touch the object
]],
	codeRenderer = [[
vec4 effect(vec4 color, Image texture, vec2 tc, vec2 pc)
{
	pc.x = pc.x/w-0.5;
	pc.y = pc.y/h-0.5;
	vec3 p = origin + planex*pc.x + planey*pc.y;
	vec3 d = (p-position) / length(p-position);
	//p=position;
	float distance = DE(p);
	int i;
	while((distance > threshold) && (i < maxIterations))
	{
		p = p+distance*d;
		distance = DE(p);
		i++;
	}
	float j = i;
	float co = 1-j/maxIterations;
	return vec4(co);
}
]]
}

function render.getPixelEffect(code)
	state, ret = pcall(function()
		return love.graphics.newPixelEffect((render.codeHeader):format(width,height)..code..render.codeRenderer)
		end
	)
	return ret
end