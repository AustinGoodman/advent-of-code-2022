datastreamBuffer = File.read("input.txt")

def hasRepeatedCharacter(string) 
	string.chars.each_with_index do |char, index|
		if (string.scan(char).length() > 1) 
			return true 
		end
	end

	return false
end

def getPacketMarker(datastreamBuffer, packetSize)
	offset = 0
	substring = datastreamBuffer[offset .. offset + (packetSize - 1)]
	
	while(hasRepeatedCharacter(substring))
		offset += 1
		substring = datastreamBuffer[offset .. offset + (packetSize - 1)]
	end

	return offset + packetSize
end

#part 1
puts getPacketMarker(datastreamBuffer, 4)

#part 2
puts getPacketMarker(datastreamBuffer, 14)