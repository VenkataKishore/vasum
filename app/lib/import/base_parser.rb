require 'csv'

module Import
  class ParseError < ::StandardError; end
  class BaseParser

    def initialize(importer, file_path, type)
      @importer = importer
      @file_path = file_path
      @type = type
    end

    protected
    def parse_csv_row # &:block
      file_content = read_with_encoding_fix
      CSV.parse(file_content, :headers => true, :header_converters => :symbol, :skip_blanks => true) do |row|
        obj = @importer.build_obj
        r = yield(row, obj)
        if @type == "only_users"
         @importer.push_obj(obj) unless (r == :skip)
        end
      end
    rescue CSV::MalformedCSVError
      error = "CSV Malformed"
      error << ": #{$!.message}" if $!.message != "CSV::MalformedCSVError"
      raise Import::ParseError, error
    end

    def read_with_encoding_fix
      content = IO.read(@file_path)
      # ignore invalid characters, see http://stackoverflow.com/a/8873922/991904
      content.encode!('UTF-16', 'UTF-8', :invalid => :replace, :replace => '')
      content.encode!('UTF-8', 'UTF-16')
      content
    end

  end
end
