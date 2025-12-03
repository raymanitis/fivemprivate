local utils = require 'modules.utils'

--- THIS WOULD BE FROM A FETCH NUI IN THE FRONTEND
RegisterNuiCallback('hideApp', function(data, cb)
    utils.ShowNUI('UPDATE_VISIBILITY', false)
    cb(true)
end)