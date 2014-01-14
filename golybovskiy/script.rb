def fl_maxima(str)
	str.sub(/- \./, '-0.').delete(' ').gsub(/^\./, '0.')
end

cmd_result = %x[echo 'if numer#false then numer:false else numer:true; u(r, z) := A*r+B*(r^3-3/2.0-4*r*z^2)+C*(r*z^4-3/2.0*r^3*z^2+1/8.0*r^5); w(r, z) := -2*A*z + 8/3.0*B*(z^3-3/2.0*r^2*z)-2/5.0*C*(z^5-5*r^2*z^3+15/8.0*r^4*z); srr(r, z) := 2/3.0*(-0.5+A+B*(3*z^2-4*z^2)+C*(z^4-9/2.0*r^2*z^2+5/8.0*r^4)); linsolve([u(0.5, 1)=0, w(0.5, 1)=-1, srr(0.5, 0)=0], [A, B, C]);' | maxima  --very-quiet]

abc_result_ar=cmd_result.split("\n").last.gsub(/\[|\]/, '').split(',').map{|a| a.split('=')}.flatten
abc_result =  Hash[*abc_result_ar]
q = {}

abc_result.each do |k, v|
	k1 = k.strip
	v1 = fl_maxima(v)
	q[k1]=v1
end

abs_result = q
puts abs_result.inspect
#abs_result = {'A'=> '-0.8', 'B'=>'0.3', 'C'=>'7'}
array = []

	u = "u(r, z) := A*r+B*(r^3-3/2.0-4*r*z^2)+C*(r*z^4-3/2.0*r^3*z^2+1/8.0*r^5)"
	w = "w(r, z) := -2*A*z + 8/3.0*B*(z^3-3/2.0*r^2*z)-2/5.0*C*(z^5-5*r^2*z^3+15/8.0*r^4*z)"
	srr = "srr(r, z) := 2/3.0*(-0.5+A+B*(3*z^2-4*z^2)+C*(z^4-9/2.0*r^2*z^2+5/8.0*r^4))"
	abs_result.each do |k, v|
		u.gsub!(k, v)
		w.gsub!(k, v)
		srr.gsub!(k, v)
	end
qq = "romberg(abs(u(r, 1))), r, 0, 0.5);"
puts "numer:true; #{u}; #{w}; #{srr}; romberg(abs(u(r, 1)), r, 0, 0.5);"
#p u, w, srr
#puts "if numer#false then numer:false else numer:true; #{u}; #{w}; #{srr}; romberg(abs(u(r, 1))), r, 0, 0.5);"
# cmd_result = %x[ echo "numer:true; #{u}; #{w}; #{srr}; romberg(abs(u(r, 1)), r, 0, 0.5);" | maxima  --very-quiet]


puts array.map{|line| fl_maxima(line.strip)}.sort.last(3)
