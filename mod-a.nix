# These are the default args
{ lib, config, options, specialArgs, foo, ... } @ args: {
  options.dumpSpecial = lib.mkOption {
    type = lib.types.raw;
  };
  config.dumpSpecial = lib.generators.toPretty {} specialArgs;
}
