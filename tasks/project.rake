require 'rake'
require 'time'

DELIVERABLE_DIR    = 'deliver'
DELIVERABLES       = %w(assets deploy doc/HOTKEYS.txt)
ARCHIVE_BASENAME   = ENV['BASE'] || 'deliverable' 
ARCHIVE_EXTENSION  = ENV['EXT']  || 'zip'
ARCHIVE_DATE       = ENV['DATE'] || '%Y.%m.%d.%H%M'

project_path = File.expand_path(File.basename(__FILE__))

# Exib Tasks  ------------------------------------------------------------------

namespace :exib do
  
  desc "Compile the MXML file into a SWF"
  task :compile do
    mxmlc_bin    = '/opt/flex/bin/mxmlc'
    source_paths = ['/Users/parker/Work/Code/EXIB/source', '/Applications/Adobe\ Flash\ CS4/Common/Configuration/ActionScript\ 3.0/projects/Flash/src/']
    mxml_file    = Dir.glob("source/*.mxml").first

    sh %{#{mxmlc_bin} -use-network=false -compiler.source-path=#{source_paths.join(',')} #{mxml_file}}
  end
  
  desc "Automatically embed files listed in .exml into the .mxml"
  task :embed do
  end
  
  desc "Packages the necessary files into a deliverable archive"
  task :package do
    archive_name = "#{ARCHIVE_BASENAME}_#{Time.now.strftime(ARCHIVE_DATE_STRING)}.#{ARCHIVE_EXTENSION}"
    sh %{7za a -mx=9 -mmt=on #{File.join(DELIVERABLE_DIR, archive_name)} #{DELIVERABLES.join}}
  end
end