d3.layout.minard = function() {

    var final = {}; //output object

    var time = function() {}, 
        Current_T, 
        decayRange,  
        data,       
        pnts_position, 
        sort,       
        Coord_T = 'coordinates', 
        segmented; 

    segmented = function(d) {
        return 1
    }

    pnts_position = function(datum) {
        
        return [datum.x,datum.y]
    }


    lineToSegments = function(values) {
        
        if (Current_T != undefined & decayRange != undefined) {
            values = values.filter(function(d) {
                return (time(d) <= Current_T && time(d) >= (Current_T-decayRange))
            })
        }



        values = d3
            .nest()
            .key(function(d) {return segmented(d)})
            .entries(values);

        tmp = values;

        output = [];


        var i = 0
        values.forEach(function(element) {
            i++;
	    if (sort!=undefined) {
		element.values.sort(sort)
	    }
            if (i==1) {
                
	    }
            var values = element.values;

            for (var i = 0; i < (values.length); i++) {
                var current = values[i];
                if (values[i+1] != undefined) {
		    current.next = values[i+1]
		} else {
		    current.next = {}
		}
                if (values[i-1] != undefined) {
                    current.previous = values[i-1]
                    if (Coord_T=="coordinates") {
                        current.coordinates = [
                            pnts_position(values[i-1]),
                            pnts_position(values[i])
                        ]
                    } else if (Coord_T=="xy") {
                        var a = pnts_position(values[i-1]),
                            b = pnts_position(values[i]);
                        current.x1=a[0]
                        current.y1=a[1]
                        current.x2=b[0]
                        current.y2=b[1]
                    }
                    current.type = "LineString";
                                    }
                current.opacity = 1-(Current_T-time(current))/decayRange
            }
	    output = output.concat(values);
        })
        return output;
    }

    final.layout = function() {
        output = lineToSegments(data);
        return output;
    }

    final.Coord_T = function(x) {
        if (!arguments.length) return Coord_T;
        Coord_T= x
        return final
    }

    final.segmented = function(x) {
        if (!arguments.length) return segmented;
        segmented= x
        return final
    }

    final.time = function(x) {
        if (!arguments.length) return time;
        time = x
        return final
    }

    final.Current_T = function(x) {
        if (!arguments.length) return Current_T;
        Current_T= x
        return final
    }

    final.decayRange = function(x) {
        if (!arguments.length) return decayRange;
        decayRange= x
        return final
    }

    final.data = function(x,append) {
        if (!arguments.length) return data;

        if (append) {
            data = data || [];
            data = data.concat(x)
        } else {
            data = x
        }

        return final
    }

    final.pnts_position = function(x) {
        if (!arguments.length) return pnts_position;
        pnts_position = x
        return final
    }
    final.sort = function(x) { 
 	if (!arguments.length) return sort; 
	    sort= x
 	return final
    } 
    


    return final;

}
