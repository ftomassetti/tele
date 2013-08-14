class Print

  def print_node(node,role='root',depth=0,shallow=false)
    mode_letter = (if shallow; 'A'; else 'C'; end)
    if node
      attrs = node.class.ecore.eAllAttributes
      attrs_strs = []
      attrs.each do |a|
        attrs_strs << "#{a.name}=#{node.send (a.name).to_sym}"
      end
      puts "#{' '*depth}#{mode_letter}:#{role}: #{node.class} [#{attrs_strs.join(', ')}]"
    else
      puts "#{' '*depth}#{mode_letter}:#{role}: nil"
    end
    unless (shallow or not node) 
      node.class.ecore.eAllReferences.each do |r|
        value = node.send (r.name).to_sym
        if value.respond_to? :each
          value.each {|e| print_node(e,r.name,depth+1,not(r.containment))}
        else
          print_node(value,r.name,depth+1,not(r.containment))
        end
      end
    end
  end

  def print_model(id)
    lang  = Models.lang_by_id id
    fn    = Models.filename_by_id id 
    model = Models.model_by_id id
    puts "== [#{lang}] #{fn} =="
    print_node(model)
  end

  def exec(*params)
    if params.count==1
      id = params[0].to_i
      if Models.has_id? id
        print_model(id)  
      else
        Console.error "no model with id = #{id}"
      end
    else
      Console.error "print <id>"
    end
  end 

end
