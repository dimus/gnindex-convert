module Migrator
  Conf = OpenStruct.new(
    JSON.parse(
      File.read(__dir__ + '../../config/config.json', symbolize_names: true)
  )
end
