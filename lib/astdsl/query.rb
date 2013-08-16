require 'emf_jruby'

module RGen

module Query

	def find_all(root,params)
		list = []
		if params.count==0
			EMF.traverse(root) {|n|	list << n}
		elsif params.count==1 and params.has_key? :type
			type = params[:type]
			EMF.traverse(root) {|n|	list << n if n.is_a? type}
		else 
			raise "Unsupported #{params}"
		end
		list
	end



end

end