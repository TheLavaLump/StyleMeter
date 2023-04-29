global function StyleModSettingsInit

void function StyleModSettingsInit(){
	AddModTitle("LavaLump Style Meter")
	AddModCategory("Style Settings")
	AddConVarSetting("DecayRate", "Style Decay Rate", "float")
	AddConVarSetting("EventExpiration", "Style Event Expiration Time (Seconds)", "float")
	AddConVarSetting("StyleMultiplyer", "Style Point Multiplyer", "float")
}
