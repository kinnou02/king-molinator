-- Safe's Buff Library
-- Written By Paul Snart
-- Copyright 2012
--
--
-- To access this from within your Add-on.
--
-- In your RiftAddon.toc
-- ---------------------
-- Embed: SafesBuffLib
-- Dependency: SafesBuffLib, {"required", "before"}
--
-- In your Add-on's initialization
-- -------------------------------
-- local LibBuff = Inspect.Addon.Detail("SafesBuffLib").data

local AddonIni, LibSBuff = ...

local LibSata = Inspect.Addon.Detail("SafesTableLib").data
