# serialFact.rb: read in serial numbers and export them as facts
# 18jun13 TJNII

factdir = "/etc/bind/serials"

begin
  files = Dir[factdir + "/*.serial"]
rescue
  # No files
  exit()
end

files.each do |file|
  Facter.add("bindserial_" + File.basename(file, ".*" )) do
    setcode do
      File.new(file, "r").gets.strip
    end
  end
end
