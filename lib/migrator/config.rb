module Migrator
  Conf = JSON.parse(
    File.read(__dir__ + '/../../config/config.json'), symbolize_names: true
  )
end
