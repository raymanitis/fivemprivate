local minimap = {}

local function getDisplayInfo()
	local resX, resY = GetActiveScreenResolution()
	local aspectRatio = GetAspectRatio(false)
	local isUltraWide = aspectRatio > 2.0
	local isUltraWide34 = (resX == 3840 and resY == 1440)
	local isUltraWide3440 = (resX == 3440 and resY == 1440)
	local is2560x1080 = (resX == 2560 and resY == 1080)
	return resX, resY, aspectRatio, isUltraWide, isUltraWide34, isUltraWide3440, is2560x1080
end

function minimap.setupMinimap()
	local _, _, _, isUltraWide, isUltraWide34, isUltraWide3440, is2560x1080 = getDisplayInfo()

	local minimapX, minimapY, minimapW, minimapH
	local maskX, maskY, maskW, maskH
	local blurX, blurY, blurW, blurH

	if isUltraWide3440 then
		minimapX, minimapY, minimapW, minimapH = -0.165, -0.080, 0.140, 0.175
		maskX, maskY, maskW, maskH = -0.098, -0.050, 0.105, 0.150
		blurX, blurY, blurW, blurH = -0.188, -0.060, 0.250, 0.220
	elseif is2560x1080 then
		minimapX, minimapY, minimapW, minimapH = -0.700, -0.120, 0.140, 0.175
		maskX, maskY, maskW, maskH = -0.633, -0.090, 0.105, 0.150
		blurX, blurY, blurW, blurH = -0.723, -0.100, 0.250, 0.220
	elseif isUltraWide34 then
		minimapX, minimapY, minimapW, minimapH = 0.030, -0.035, 0.140, 0.175
		maskX, maskY, maskW, maskH = 0.047, -0.005, 0.105, 0.150
		blurX, blurY, blurW, blurH = 0.007, -0.015, 0.250, 0.220
	elseif isUltraWide then
		minimapX, minimapY, minimapW, minimapH = 0.028, -0.036, 0.135, 0.170
		maskX, maskY, maskW, maskH = 0.050, -0.006, 0.100, 0.145
		blurX, blurY, blurW, blurH = 0.005, -0.016, 0.245, 0.215
	else
		minimapX, minimapY, minimapW, minimapH = -0.0045, -0.038, 0.150, 0.188888
		maskX, maskY, maskW, maskH = 0.020, -0.008, 0.111, 0.159
		blurX, blurY, blurW, blurH = -0.03, -0.018, 0.266, 0.237
	end

	SetMinimapComponentPosition('minimap', 'L', 'B', minimapX, minimapY, minimapW, minimapH)
	SetMinimapComponentPosition('minimap_mask', 'L', 'B', maskX, maskY, maskW, maskH)
	SetMinimapComponentPosition('minimap_blur', 'L', 'B', blurX, blurY, blurW, blurH)

	SetBlipAlpha(GetNorthRadarBlip(), 0)
	SetBigmapActive(true, false)
	SetMinimapClipType(0)
	CreateThread(function()
		local timeout = 0
		while timeout < 10000 do
			SetBigmapActive(false, false)
			SetRadarZoom(1100)
			Wait(1000)
			timeout = timeout + 1000
		end
	end)
end

function minimap.applyMinimapTextures(shape)
	local _, _, _, isUltraWide, isUltraWide34, isUltraWide3440, is2560x1080 = getDisplayInfo()
	local targetShape = (shape == 'circle') and 'circle' or 'square'

	if targetShape == 'square' then
		local dict = 'squaremap'
		RequestStreamedTextureDict(dict, false)
		local waited = 0
		while not HasStreamedTextureDictLoaded(dict) and waited < 2000 do
			Wait(50)
			waited = waited + 50
		end
		SetMinimapClipType(0)
		AddReplaceTexture('platform:/textures/graphics', 'radarmasksm', dict, 'radarmasksm')
		AddReplaceTexture('platform:/textures/graphics', 'radarmask1g', dict, 'radarmasksm')

		local minimapX, minimapY, minimapW, minimapH
		local maskX, maskY, maskW, maskH
		local blurX, blurY, blurW, blurH

		if isUltraWide3440 then
			minimapX, minimapY, minimapW, minimapH = -0.170, -0.089, 0.155, 0.170
			maskX, maskY, maskW, maskH = 0.0, 0.0, 0.120, 0.185
			blurX, blurY, blurW, blurH = -0.179, -0.025, 0.255, 0.285
		elseif is2560x1080 then
			minimapX, minimapY, minimapW, minimapH = -0.705, -0.129, 0.155, 0.170
			maskX, maskY, maskW, maskH = 0.0, 0.0, 0.120, 0.185
			blurX, blurY, blurW, blurH = -0.714, -0.065, 0.255, 0.285
		elseif isUltraWide34 then
			minimapX, minimapY, minimapW, minimapH = 0.035, -0.044, 0.155, 0.170
			maskX, maskY, maskW, maskH = 0.0, 0.0, 0.120, 0.185
			blurX, blurY, blurW, blurH = 0.026, 0.020, 0.255, 0.285
		elseif isUltraWide then
			minimapX, minimapY, minimapW, minimapH = 0.033, -0.045, 0.150, 0.165
			maskX, maskY, maskW, maskH = 0.0, 0.0, 0.115, 0.180
			blurX, blurY, blurW, blurH = 0.025, 0.018, 0.250, 0.280
		else
			minimapX, minimapY, minimapW, minimapH = 0.0, -0.047, 0.1638, 0.183
			maskX, maskY, maskW, maskH = 0.0, 0.0, 0.128, 0.20
			blurX, blurY, blurW, blurH = -0.01, 0.025, 0.262, 0.300
		end

		SetMinimapComponentPosition('minimap', 'L', 'B', minimapX, minimapY, minimapW, minimapH)
		SetMinimapComponentPosition('minimap_mask', 'L', 'B', maskX, maskY, maskW, maskH)
		SetMinimapComponentPosition('minimap_blur', 'L', 'B', blurX, blurY, blurW, blurH)
	else
		local dict = 'minimap'
		RequestStreamedTextureDict(dict, false)
		local waited = 0
		while not HasStreamedTextureDictLoaded(dict) and waited < 2000 do
			Wait(50)
			waited = waited + 50
		end
		SetMinimapClipType(1)
		AddReplaceTexture('platform:/textures/graphics', 'radarmasksm', dict, 'radarmasksm')
		AddReplaceTexture('platform:/textures/graphics', 'radarmask1g', dict, 'radarmasksm')

		local minimapX, minimapY, minimapW, minimapH
		local maskX, maskY, maskW, maskH
		local blurX, blurY, blurW, blurH

		if isUltraWide3440 then
			minimapX, minimapY, minimapW, minimapH = -0.165, -0.072, 0.170, 0.245
			maskX, maskY, maskW, maskH = 0.023, 0.0, 0.060, 0.185
			blurX, blurY, blurW, blurH = -0.159, -0.033, 0.245, 0.325
		elseif is2560x1080 then
			minimapX, minimapY, minimapW, minimapH = -0.700, -0.112, 0.170, 0.245
			maskX, maskY, maskW, maskH = 0.023, 0.0, 0.060, 0.185
			blurX, blurY, blurW, blurH = -0.694, -0.073, 0.245, 0.325
		elseif isUltraWide34 then
			minimapX, minimapY, minimapW, minimapH = 0.030, -0.027, 0.170, 0.245
			maskX, maskY, maskW, maskH = 0.233, 0.0, 0.060, 0.185
			blurX, blurY, blurW, blurH = 0.036, 0.012, 0.245, 0.325
		elseif isUltraWide then
			minimapX, minimapY, minimapW, minimapH = 0.028, -0.028, 0.165, 0.240
			maskX, maskY, maskW, maskH = 0.228, 0.0, 0.058, 0.180
			blurX, blurY, blurW, blurH = 0.035, 0.010, 0.240, 0.320
		else
			minimapX, minimapY, minimapW, minimapH = -0.0100, -0.030, 0.180, 0.258
			maskX, maskY, maskW, maskH = 0.200, 0.0, 0.065, 0.20
			blurX, blurY, blurW, blurH = -0.00, 0.015, 0.252, 0.338
		end

		SetMinimapComponentPosition('minimap', 'L', 'B', minimapX, minimapY, minimapW, minimapH)
		SetMinimapComponentPosition('minimap_mask', 'L', 'B', maskX, maskY, maskW, maskH)
		SetMinimapComponentPosition('minimap_blur', 'L', 'B', blurX, blurY, blurW, blurH)
	end

	SetBlipAlpha(GetNorthRadarBlip(), 0)
	SetRadarBigmapEnabled(true, false)
	Wait(50)
	SetRadarBigmapEnabled(false, false)
end

return minimap


