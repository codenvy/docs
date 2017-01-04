#
#  2012-2017 Codenvy, S.A.
#  All Rights Reserved.
#
# NOTICE:  All information contained herein is, and remains
# the property of Codenvy S.A. and its suppliers,
# if any.  The intellectual and technical concepts contained
# herein are proprietary to Codenvy S.A.
# and its suppliers and may be covered by U.S. and Foreign Patents,
# patents in process, and are protected by trade secret or copyright law.
# Dissemination of this information or reproduction of this material
# is strictly forbidden unless prior written permission is obtained
# from Codenvy S.A..
#

module Reading
  class Generator < Jekyll::Generator
    def generate(site)
      begin
          docs = site.docs_to_write
          entries = {}
          site.collections["docs"].filtered_entries.each do |entry|
            page = ""
            site.config["defaults"].each do |default|
                scope = default["scope"]
                path = scope["path"]
                full_path = "_docs/" + entry
                if full_path.include? path
                    value = default["values"]
                    categories = value["categories"]
                    categories.each do |category|
                        page=page+"/"+category
                    end
                end
            end
            depth = page.split('/').size - 1
            base = ''
            if depth <= 1
                base = '..'
            elsif depth == 2
                base = '../..'
            elsif depth == 3
                base = '../../..'
            elsif depth == 4
                base = '../../../..'      
            end
            entries[entry]=base+page 
          end
          collections = {}
          site.config["collections"].each do |collection|
            if collection[0] != "posts"
              collections=collections.merge(get_col(site,collection[0],entries))
            end
          end     
          # puts collections
          site.config["links"] = collections
      rescue 
          red = "\033[0;31m"
          puts red + "Jekyll> There is an error in the ruby plugin file _plugins/links.rb." 
          puts red + "Jekyll> Check collection files such ass 'docs.yml' and 'tutorials.yml' under _data/ folder are formatted correctly."
          puts ""
          raise
      end
    end
    
    def get_col(site,col_name, entries)
        collections = {}
        hash1 = site.data
        hash1.each do |hash2|
            hash3 = hash1[col_name]
            hash3.each do |hash4|
                
                files = hash4[col_name]                
                files.each do |file|
                    parse = file.split('-')
                    parse.shift
                    parse = parse.join('-')
                    entries.keys.any? {|k| 
                        if k.include? file 
                            collections[file]=entries[k]+"/"+parse+"/index.html"
                        end
                        }
                end
            end
        end
        return collections
    end
  end
end
