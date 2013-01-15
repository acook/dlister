require 'pathname'
require 'dlister/file_info'
#require 'dlister/parse_git'
require 'dlister/color'

module Dlister
  class DirList
    include Dlister::Color

    def initialize path
      @path = Pathname.new(path).expand_path
    end
    attr :path

    def info
      FileInfo.for_path path
    end

    def git
      ParseGit.for_path path
    end

    def to_s
      entries = sorted.map do |(entry, attributes)|
        entry_to_s entry, attributes
      end

      width = console_width
      spacer = '  '
      newline = "\n"

      entries.inject([[]]) do |lines, entry|
        if length(lines.last + [entry], spacer) <= width then
          lines[-1] << entry
        else
          lines[-1] = lines[-1].join spacer
          lines << [entry]
        end
        lines
      end.join newline
    end

    def sorted
      order = [:directory, :executable, :file, :link, :invalid_link]
      to_hash.sort do |(entry_a, attr_a), (entry_b, attr_b)|
        type_a, type_b = attr_a[:real_type], attr_b[:real_type]

      type_sort = order.index(type_a) <=> order.index(type_b)

      if type_sort == 0 then
        if entry_a =~ /^\d/ && entry_b =~ /^\d/ then
          entry_a.to_i <=> entry_b.to_i
        else
          entry_a <=> entry_b
        end
      else
        type_sort
      end
      end
    end

    def to_a
      to_hash.inject(Array.new) do |list, (entry, attributes)|
        list << [
          entry,
          attributes
      ]
      end
    end

    def to_hash
      info #.merge git
    end

    def entry_to_s entry, attributes
      type = attributes[:type]

      text = String.new

      text << colormap(type)
      text << entry

      text << normal
      text << glyphmap(type)

      text << normal
      text << bright(:black)
      text << ':'
      text << type.to_s
    end

    def glyphmap type
      case type
      when :directory  then '/'
      when :link       then "\u2A1D"
      when :file       then ''
      when :executable then "\u25B7"
      when :invalid_link then "\u02E3"
      else ''
      end
    end

    def colormap type
      case type
      when :directory  then bright :blue
      when :link       then fg :yellow
      when :file       then fg :normal
      when :executable then bright :green
      when :invalid_link then bg :red
      else fg :normal
      end
    end

    def length text, spacer = ''
      cleaned(text.join spacer).length
    end

    def cleaned text
      ansi_color_codes = /\e\[\d+(?>(;\d+)*)m/
      text.gsub ansi_color_codes, ''
    end
  end
end
