require "dlister/version"
require 'dlister/dir_list'

module Dlister
  module_function

  def list paths
    @paths = paths

    @paths.sort.each_with_index do |path, index|
      puts "#{path}:" if many?

      puts DirList.new path

      puts if many? && not_last?(index)
    end
  end

  def count
    @paths.length
  end

  def not_last? index
    index + 1 < count
  end

  def many?
    count > 1
  end

end

