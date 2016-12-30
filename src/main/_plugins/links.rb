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
