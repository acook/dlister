class FileInfo

  def self.for_path path
    if path.directory? then
      contents = Hash.new
      path.each_child(true) do |entry|
        info = self.new entry
        contents[info.name] = info.attributes
      end
      contents
    else
      info = self.new path
      {info.name => info.attributes}
    end
  end

  def initialize path
    @path = path
  end
  attr :path

  def type
    if !path.exist? then
      if path.symlink? then
        :invalid_link
      else
        :not_found
      end
    elsif path.symlink? then
      :link
    elsif path.executable? then
      if path.directory? then
        :directory
      else
        :executable
      end
    else
      path.ftype.to_sym
    end
  end

  def real_type
    if type == :link then
      self.class.new(path.readlink).real_type
    else
      type
    end
  end

  def basename
    path.basename
  end

  def attributes
    {type: type, real_type: real_type}
  end

  def name
    basename.to_s
  end
end
