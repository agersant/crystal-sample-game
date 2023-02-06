package.path = package.path .. ";crystal/runtime/?.lua" -- TODO remove this when engine files don't get included all over the place anymore

require("crystal");
