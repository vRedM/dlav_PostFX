local function toggleNuiFrame(shouldShow)
  SetNuiFocus(shouldShow, shouldShow)
  SendReactMessage('setVisible', shouldShow)
end

RegisterCommand('show-animpostfx-menu', function()
  toggleNuiFrame(true)
  debugPrint('Show NUI frame')
end)

RegisterNUICallback('hideFrame', function(_, cb)
  toggleNuiFrame(false)
  debugPrint('Hide NUI frame')
  cb({})
end)

RegisterNUICallback('getClientData', function(data, cb)
  debugPrint('Data sent by React', json.encode(data))
  print("DebugDataSent")
-- Lets send back client coords to the React frame for use
  local curCoords = GetEntityCoords(PlayerPedId())

  local retData <const> = { x = curCoords.x, y = curCoords.y, z = curCoords.z }
  cb(retData)
end)

-- Tableau pour stocker les identifiants des VFX
local vfxHandles = {}

RegisterNUICallback('someNuiCallback', function(data)
    -- Traitement de la chaîne de caractères reçue du client React
    savedData = data
    print(savedData)

    -- Si un VFX est déjà actif, le supprimer avant de créer le nouveau
    if #vfxHandles > 0 then
        for _, handle in ipairs(vfxHandles) do
            Citizen.InvokeNative(0x459598F579C98929, handle, false)   -- RemoveParticleFx
        end
        vfxHandles = {}  -- Effacer le tableau des identifiants des VFX
    end

    AnimpostfxStopAll()
    AnimpostfxPlay(savedData)


end)



RegisterNUICallback('setClientVFX', function(data, cb)

end)



	


    RegisterCommand('stopVFX', function()
      if Citizen.InvokeNative(0x9DD5AFF561E88F2A, current_ptfx_handle_id) then   -- DoesParticleFxLoopedExist
        Citizen.InvokeNative(0x459598F579C98929, current_ptfx_handle_id, false)   -- RemoveParticleFx
      end
    end)