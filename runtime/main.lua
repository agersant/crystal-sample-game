-- TODO Find a way for crystal/init.lua to do this itself
package.path = package.path .. ";crystal/runtime/?.lua";
require("crystal/runtime");

love.filesystem.setIdentity("crystal-sample-game");
