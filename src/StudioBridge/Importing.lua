--[[
  Imports the file structure exported by our server.
--]]

local http = game:GetService("HttpService")

local URL = "localhost"
local PORT = 8080

local function isAService(name)
  return pcall(function()
    return game:FindService(name)
  end)
end

local function newScript(name, className, source, parent)
  local src = Instance.new(className or "Script")
  src.Name = name
  src.Source = source
  src.Parent = parent

  return src
end

local function newFolder(name, parent)
  local folder = Instance.new("Folder")
  folder.Name = name
  folder.Parent = parent

  return folder
end

local function handleExistingScript(instance, properties)
  if instance.ClassName == properties.ClassName then
    instance.Source = properties.Source
  else
    local replacement = newScript(properties.Name, properties.ClassName,
      properties.Source, instance.Parent)

    instance:Destroy()

    return replacement
  end
end

local function handleExistingInstance(instance, properties)
  if instance:IsA("LuaSourceContainer") and properties.Source then
    return handleExistingScript(instance, properties)
  end

  return instance
end

local function getInstance(properties, parent)
  local name = properties.Name
  local existingInstance = parent:FindFirstChild(name)

  if parent == game and isAService(name) then
    return game:GetService(name)
  elseif existingInstance then
    return handleExistingInstance(existingInstance, properties)
  else
    if properties.Source then
      return newScript(properties.Name, properties.ClassName, properties.Source,
        parent)
    else
      return newFolder(properties.Name, parent)
    end
  end
end

local function importHierarchy(hierarchy, parent)
  local parent = parent or game

  for _, properties in ipairs(hierarchy) do
    local instance = getInstance(properties, parent)

    if properties.Children then
      importHierarchy(properties.Children, instance)
    end
  end
end

--------------------------------------------------------------------------------

local importing = {}

function importing.importFromServer()
  local server = "http://" .. URL .. ":" .. PORT
  local hierarchy = http:JSONDecode(http:GetAsync(server))
  importHierarchy(hierarchy)
end

function importing.protectedImport()
  local success, message = pcall(importing.importFromServer)

  if not success then
    warn(message)
  end

  return success
end

return importing
