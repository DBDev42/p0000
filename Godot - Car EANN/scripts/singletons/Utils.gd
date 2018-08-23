extends Node

# Returns the next unique id in the sequence.
#func next_id() -> int :
func uuidv4() :
	Logger.debug("Start func Utils.uuidv4()")
	var result = null
	
	var bytes = PoolByteArray()
	for i in range(16) :
		bytes.append(randi() % 256)
	bytes[6] = (bytes[6] & 0x0f) | 0x40
	bytes[8] = (bytes[8] & 0x3f) | 0x80
	result = "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x" % [bytes[0], bytes[1], bytes[2], bytes[3], bytes[4], bytes[5], bytes[6], bytes[7], bytes[8], bytes[9], bytes[10], bytes[11], bytes[12], bytes[13], bytes[14], bytes[15]]
	
	Logger.debug("Start func Utils.uuidv4 return: " + result)
	return result