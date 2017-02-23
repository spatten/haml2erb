desc "This task will take the supplied .haml input file and convert it to .erb.  It will remove the original .haml file and create a new .erb file"
task :haml2erb, [:filename] => :environment do |t, args|
  output_file = args[:filename].gsub(/\.haml/, '.erb')
  p output_file
  File.open(output_file, 'w') { |f| f.write Haml2Erb.convert(File.open(args[:filename], 'r').read) }
  FileUtils.rm_r args[:filename]
end
