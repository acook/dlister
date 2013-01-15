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
      entries = remap_entries entry_sort(info)
      clean_entries = entries.map{|entry| clean entry }

      if clean_entries.join(spacer).length < width then
        entries.join spacer
      else
        columnize entries, clean_entries
      end
    end

    def columnize entries, clean_entries
      longest_entry = clean_entries.max{|a,b| a.length <=> b.length }
      column_width = longest_entry.length + spacer.length
      columns = width / column_width

      lines = Array.new
      entries.each_slice(columns) do |line|
        lines << line.map do |entry|
          entry + (' ' * (column_width - clean(entry).length))
        end.join
      end
      lines.join newline
    end

    def entry_sort entries
      order = [:directory, :executable, :file, :link, :invalid_link]

      entries.sort do |(entry_a, attr_a), (entry_b, attr_b)|
        rtype_a, rtype_b = attr_a[:real_type], attr_b[:real_type]

        rtype_sort = order.index(rtype_a) <=> order.index(rtype_b)

        if rtype_sort == 0 then
          if entry_a =~ /^\d/ && entry_b =~ /^\d/ then
            entry_a.to_i <=> entry_b.to_i
          else
            entry_a <=> entry_b
          end
        else
          rtype_sort
        end
      end
    end

    def remap_entries entries
      entries.map do |entry, attributes|
        entry_to_s entry, attributes
      end
    end

    def entry_to_s entry, attributes
      type = attributes[:type]
      real_type = attributes[:real_type]

      text = String.new

      text << colormap(type)
      text << entry

      text << normal
      text << glyphmap(type)

      if type != real_type then
        text << glyphmap(real_type)
      else
        text
      end
    end

    def glyphmap type
      {
        directory:    '/',
        link:         "\u2A1D",
        file:         '',
        executable:   "\u25B7",
        invalid_link: "\u02E3"
      }[type] || ''
    end

    def colormap type
      {
        directory:    bright(:blue),
        link:         fg(:yellow),
        file:         fg(:normal),
        executable:   bright(:green),
        invalid_link: bg(:red)
      }[type] || fg(:normal)
    end

    def clean text
      ansi_color_codes = /\e\[\d+(?>(;\d+)*)m/
      text.gsub ansi_color_codes, ''
    end

    def width
      @width ||= console_width
    end

    def spacer
      '  '
    end

    def newline
      "\n"
    end
  end
end
