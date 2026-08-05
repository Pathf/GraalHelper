local _, GraalHelper = ...

function GraalHelper:UpdateZoomOut()
    SetCVar("cameraDistanceMaxZoomFactor", GraalHelper.config.cameraMaxZoom)
end
