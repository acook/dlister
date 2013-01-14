require "dlister/version"
require 'dlister/dir_list'

module Dlister
  module_function

  def list path
    DirList.new path
  end
end

