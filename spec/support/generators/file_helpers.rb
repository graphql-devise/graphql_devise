require 'fileutils'

module Generators
  module FileHelpers
    def create_file_with_content(path, content)
      FileUtils.mkdir(File.dirname(path))
      File.open(path, 'w') do |f|
        f.write(content)
      end
    end
  end
end
