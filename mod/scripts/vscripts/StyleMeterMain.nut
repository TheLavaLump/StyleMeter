global function StyleMeterInit


array < var > StyleRankRuis = [null, null]
array < var > StyleEventSlots = [null, null, null, null, null]
var PercentageBarTopo = null
var percentageRui = null

var topology = null

void function StyleMeterInit()
{
	topology = RuiTopology_CreateSphere(COCKPIT_RUI_OFFSET - <0, 82, -21>, <0, -1, 0.037>, <0, 0.00, -1>, COCKPIT_RUI_RADIUS, COCKPIT_RUI_WIDTH * 0.15, COCKPIT_RUI_HEIGHT * 0.003, COCKPIT_RUI_SUBDIV)
	entity player = GetLocalClientPlayer()
	AddLocalPlayerDidDamageCallback(OnDamage)
	PercentageBarTopo = topology
	AddCallback_OnPlayerKilled(KillEvent)
	StyleRuiSetup()
	thread UpdateRankUI()
	TimeSinceLast = Time()
}

	//Khalmee's stuff
	/*
	//This was an attempt to make a background for the meter, but after realizing how big it is i dropped the idea. Experiment with that as you will.
	var cringe = RuiTopology_CreatePlane( <1600,300,0>, <300, 0, 0>, <0, 400, 0>, false ) //(origin, stretchX, stretchY, ?)
	var moreCringe = RuiCreate( $"ui/basic_image.rpak", cringe, RUI_DRAW_HUD, -1 )
    RuiSetFloat3(moreCringe, "basicImageColor", <0,0,0>)
    RuiSetFloat(moreCringe, "basicImageAlpha", 0.5)
	*/
	//end

array < string > SlotStrings = ["", "", "", "", ""]
array < vector > SlotCols = [<0.5, 0.5, 0.5>, <0.5, 0.5, 0.5>, <0.5, 0.5, 0.5>, <0.5, 0.5, 0.5>, <0.5, 0.5, 0.5>]
array < float > StyleRanks = [0.0, 0.01, 2.0, 4.0, 6.0, 8.0, 10.0, 12.0, 14.0]
array < string > StyleRankStrings = ["", ""]

float StyleBarWidth = 0.15
int StyleStreak = 0
int Multikill = 0
bool Slot1Full = false
int PlayerStreak = 0
#if CLIENT
float TimeSinceLast = 0
float TimeNow = 0
float StylePoints = 0.0
float StyleEventAlpha = 1.0
float StylePosX1 = 0.8
float StylePosY1 = 0.2
vector StyleCol1 = <1.0, 1.0, 1.0>
vector StyleCol2 = <1.0, 1.0, 1.0>
vector PercentageCol = <1.0, 1.0, 1.0>
vector StylePos1 = < 0.8, 0.2, 0>
vector StylePos2 = <0.92, 0.23, 0>
float StyleScale2 = 50.0
float StylePointPercenage = 0.0

float HammerUnitDist = 0.0
float MeterDist = 0.0

array < vector > Rarity = [<0.5, 0.5, 0.5>, <1.0, 1.0, 1.0>, <0.0, 1.0, 1.0>, <1.0, 0.0, 0.0>]

entity RecentlyAttackedPlayer = null

void function KillEvent( ObituaryCallbackParams KillEventParams ){
	entity player = GetLocalClientPlayer()
	if((KillEventParams.victim == RecentlyAttackedPlayer) && (player != KillEventParams.attacker) && (!KillEventParams.victimIsOwnedTitan)){
		AddStyleEvent( "Assist", 1.0, Rarity[0])
		if(KillEventParams.damageSourceId == 206){
			AddStyleEvent( "Envirokill", 3.0, Rarity[2])
		}
		else if(KillEventParams.damageSourceId == 211){
			AddStyleEvent( "Out of Bounds", 3.0, Rarity[2])
		}
	}
	if(KillEventParams.attacker == GetLocalClientPlayer()){

		// Created by Mauer
		HammerUnitDist = Distance(player.EyePosition(), KillEventParams.victim.GetOrigin())
		MeterDist = HammerUnitDist * 0.07616/3

		// Created by in1tiate, adapted from code by Dinorush
		// Checks if the dead player was at least 1500 hammer units above solid ground when they died.
		// Needs refinement, breaks on some maps and detects gooses when they did not occur
		//TraceResults gooseTest = TraceLine (KillEventParams.victim.GetOrigin(), 
		//KillEventParams.victim.GetOrigin() + < 0.0, 0.0, -1500.0>, [KillEventParams.victim],
		//TRACE_MASK_SHOT, TRACE_COLLISION_GROUP_BLOCK_WEAPONS )
		if(KillEventParams.victim == GetLocalClientPlayer() && KillEventParams.damageSourceId == 179){
			AddStyleEvent( "literally 1984", 0.0, Rarity[1]) //If you get killed by mind_crime
		}
		if (KillEventParams.victim == GetLocalClientPlayer()) { // Player killed themselves
			StyleStreak = 0
			AddStyleEvent( "Suicide", 0.0, Rarity[1] )
			return
		}

		StyleStreak++
		if(KillEventParams.victim.IsTitan() && KillEventParams.victimIsOwnedTitan){
			AddStyleEvent( "titan kill", 1.0, Rarity[1] )
			if (KillEventParams.damageSourceId == 185){
				AddStyleEvent( "Termination", 0.2, Rarity[2] ) //Titan execution
			}
			if(KillEventParams.victim.IsTitan() && !player.IsTitan()){
			AddStyleEvent( "takedown", 2.0, Rarity[3] )
			}//Titan kill as pilot
		}
		if (Multikill > 1){
			AddStyleEvent( "Multikill X" + Multikill, 1.0, Rarity[2] ) // Multikills
		}
		switch(StyleStreak){
			case 3:
				AddStyleEvent( "Streak", 1.0, Rarity[1] )
					break
			case 6:
				AddStyleEvent( "Great Streak", 1.0, Rarity[2] )
					break
			case 10:
				AddStyleEvent( "Untouchable", 1.0, Rarity[3] )
					break
			default:
				break
		}
		if(KillEventParams.victim.IsPlayer && !KillEventParams.victimIsOwnedTitan){
			Multikill++
			AddStyleEvent("Pilot Kill", 2.0, Rarity[1] )
			
			//if(gooseTest.fraction == 1) { // Goose (kill on ejecting pilot)
			//	AddStyleEvent( "Goosed", 2.5, Rarity[2] )
			//}
			if (MeterDist >= 40.00){ // Longshots
				AddStyleEvent( "longshot " + format("%.1f", MeterDist) + "m", 2.0, Rarity[2] ) // Also Created by Mauer
			}
			if(KillEventParams.damageSourceId == 119 && GetLocalClientPlayer().GetZoomFrac() < 0.5|| KillEventParams.damageSourceId == 103 && GetLocalClientPlayer().GetZoomFrac() < 0.5|| KillEventParams.damageSourceId == 97 && GetLocalClientPlayer().GetZoomFrac() < 0.5|| KillEventParams.damageSourceId == 130 && GetLocalClientPlayer().GetZoomFrac() < 0.5|| KillEventParams.damageSourceId == 45 && GetLocalClientPlayer().GetZoomFrac() < 0.5){
				AddStyleEvent( "No-Scope", 2.0, Rarity[2]) // No-Sope for the dmr, kraber, double take, charge rifle and railgun
			}
			switch(KillEventParams.damageSourceId){
				case 110:
					AddStyleEvent( "Incineration", 0.5, Rarity[0] ) //Firestar
						break
				case 237:
					AddStyleEvent( "Incineration", 0.5, Rarity[0] ) //Thermal shield
						break
				case 75:
					AddStyleEvent( "Incineration", 0.5, Rarity[0] ) //Flame core
						break
				case 40:
					AddStyleEvent( "Incineration", 0.5, Rarity[0] ) //Thermite launcher
						break
				case 57:
					AddStyleEvent( "Incineration", 0.5, Rarity[0] ) //Fire wall
						break	
				case 238:
					AddStyleEvent( "Incineration", 0.5, Rarity[0] ) //Gas trap probably (Its so hard to get kills with that I cant verify)
						break
				case 126:
					AddStyleEvent( "Obliterated", 0.2, Rarity[0] ) // Cold war
						break
				case 135:
					AddStyleEvent( "Obliterated", 0.2, Rarity[0] ) //Epg
						break
				case 77:
					AddStyleEvent( "Obliterated", 0.2, Rarity[0] ) //Laser core
						break	
				case 65:
					AddStyleEvent( "Obliterated", 0.2, Rarity[0] ) //Laser shot
						break
				case 151:
					AddStyleEvent( "Sliced", 0.5, Rarity[0] ) // Ronin sword
						break
				case 152:
					AddStyleEvent( "Sliced", 0.5, Rarity[0] ) // Ronin sword (Again)
						break
				case 119:
					AddStyleEvent( "Obliterated", 0.2, Rarity[0] ) //Charge Rifle
						break
				case 140:
					AddStyleEvent( "Disrespect", 0.2, Rarity[0] ) // Pilot melee
						break
				case 186:
					AddStyleEvent( "Execution", 3.0, Rarity[2] ) //Pilot execution
						break
				case 45:
					AddStyleEvent( "Railcannoned", 0.2, Rarity[0] ) // Railgun
						break
				case 111:
					AddStyleEvent( "Bankrupt", 3.0, Rarity[2]) //Pulse blade
						break
				case 85:
					AddStyleEvent( "Why are you even using this", 0.1, Rarity[0]) //Electric smoke nades
						break
				case 47:
					AddStyleEvent( "Reversal", 2.0, Rarity[2]) // Vortex sheild
						break
				case 48:
					AddStyleEvent( "Reversal", 2.0, Rarity[2]) // Vortex sheild (again)
						break
				case 64:
					AddStyleEvent( "Baited", 1.5, Rarity[2]) // Laser tripwire
						break
				case 162:
					AddStyleEvent( "Automated", 1.0, Rarity[2]) // Pilot sentry 
				default:
					break
			}
		}
		if (KillEventParams.damageSourceId == 44){
			AddStyleEvent( "Nuke", 4.0, Rarity[2] )//Nuclear eject
		}
	}
}

void function AddStyleFromDmg( float num ){
	StylePoints += (num * GetConVarFloat("StyleMultiplyer"))
}

void function OnDamage( entity player, entity victim, vector Pos, int scriptDamageType){
	RecentlyAttackedPlayer = victim
	if (victim == player) { // Self-damage penalty
		AddStyleFromDmg(-0.5)
		return
	}
	AddStyleFromDmg(0.1)
	if(scriptDamageType & DF_KILLSHOT){
		if(!victim.IsPlayer()){
			AddStyleEvent( "kill", 0.4, Rarity[0]) // Ai kills
		}
		if(scriptDamageType & DF_HEADSHOT){ // Headshot kills
			AddStyleEvent("Headshot", 0.2, Rarity[0])
		}
	}

}

void function AddStyleEvent( string name, float amount, vector rarity ){
	TimeSinceLast = Time()
	StylePoints += (amount * GetConVarFloat("StyleMultiplyer"))
	if (Slot1Full == false){
		SlotStrings[0] = ("+" + name)
		SlotCols[0] = rarity
		Slot1Full = true
		StyleEventAlpha = 1.0
		TimeSinceLast = Time()
	}
	else {	//A really bad way to move the events down one slot if Slot1 is full
		SlotStrings[4] = SlotStrings[3]
		SlotCols[4] = SlotCols[3]
		SlotStrings[3] = SlotStrings[2]
		SlotCols[3] = SlotCols[2]
		SlotStrings[2] = SlotStrings[1]
		SlotCols[2] = SlotCols[1]
		SlotStrings[1] = SlotStrings[0]
		SlotCols[1] = SlotCols[0]
		SlotStrings[0] = ("+" + name)
		SlotCols[0] = rarity
		TimeSinceLast = Time()
		StyleEventAlpha = 1.0
	}
}


void function UpdateRankUI(){
	while(true){
	
		TimeNow = Time()
		StyleScale2 = 50.0
		//Khalmee's
		//Functions adding speed and air time bonuses encased in an IF containing various edge cases.
		//For now I'm turning Air time gain off, since it has problems with match intro and dropping titans, besides that it works fine but I'm not satisfied.
		if(!IsLobby() && !IsWatchingReplay() && GetLocalClientPlayer() != null && IsAlive(GetLocalClientPlayer())){
			AddStyleFromSpeed()
			//AddStyleFromAirTime()
		}
		//end
		if (StylePoints == StyleRanks[0]){
			StyleRankStrings = ["", ""]
			StyleCol1 = <1.0, 1.0, 1.0>
			StylePos2 = <0.8, 0.2, 0>
		}
		if (StylePoints > StyleRanks[1]){
			StyleRankStrings = ["D", "estructive"]
			StyleCol1 = <0.0, 0.58039215686, 1.0>
			StyleCol2 = <1.0, 1.0, 1.0>
			StylePos2 = <0.82, 0.23, 0>
		}
		if (StylePoints > StyleRanks[2]){
			StyleRankStrings = ["C", "haotic"]
			StyleCol1 = <0.31372549019, 0.98823529411, 0.0156862745>
			StyleCol2 = <1.0, 1.0, 1.0>
			StylePos2 = <0.82, 0.23, 0>
		}
		if (StylePoints > StyleRanks[3]){
			StyleRankStrings = ["B", "rutal"]
			StyleCol1 = <0.98823529411, 0.83137254902, 0.0156862745>
			StyleCol2 = <1.0, 1.0, 1.0>
			StylePos2 = <0.82, 0.23, 0>
		}
		if (StylePoints > StyleRanks[4]){
			StyleRankStrings = ["A", "narchic"]
			StyleCol1 = <1.0, 0.42352941176, 0.0156862745>
			StyleCol2 = <1.0, 1.0, 1.0>
			StylePos2 = <0.82, 0.23, 0>
		}
		if (StylePoints > StyleRanks[5]){
			StyleRankStrings = ["S", "upreme"]
			StyleCol1 = <1.0, 0.0156862745, 0.0156862745>
			StyleCol2 = <1.0, 1.0, 1.0>
			StylePos2 = <0.82, 0.23, 0>
		}
		if (StylePoints > StyleRanks[6]){
			StyleRankStrings = ["SS", "adistic"]
			StyleCol1 = <1.0, 0.0156862745, 0.0156862745>
			StyleCol2 = <1.0, 1.0, 1.0>
			StylePos2 = <0.8375, 0.23, 0>
		}
		if (StylePoints > StyleRanks[7]){
			StyleRankStrings = ["SSS", "hitstorm"]
			StyleCol1 = <1.0, 0.0156862745, 0.0156862745>
			StyleCol2 = <1.0, 1.0, 1.0>
			StylePos2 = <0.855, 0.23, 0>
		}
		if (StylePoints > StyleRanks[8]){
			StyleRankStrings = ["ULTRAFALL", "ULTRAFALL"]
			StyleCol1 = <1.0, 0.8431372549, 0.0>
			StyleCol2 = <1.0, 0.4431372549, 0.0>
			StyleScale2 = 70.0
			StylePos2 = StylePos1 + <0.002, 0.002, 0>
			}
		//Refresh the Rui of the style meter
		RuiSetFloat2(StyleEventSlots[0], "msgPos", StylePos1 + <0, 0.10, 0>)
		RuiSetFloat(StyleEventSlots[0], "msgAlpha", StyleEventAlpha)
		RuiSetFloat3(StyleEventSlots[0], "msgColor", SlotCols[0])
		RuiSetString(StyleEventSlots[0], "msgText", SlotStrings[0])

		RuiSetFloat2(StyleEventSlots[1], "msgPos", StylePos1 + <0, 0.13, 0>)
		RuiSetFloat(StyleEventSlots[1], "msgAlpha", StyleEventAlpha)
		RuiSetFloat3(StyleEventSlots[1], "msgColor", SlotCols[1])
		RuiSetString(StyleEventSlots[1], "msgText", SlotStrings[1])

		RuiSetFloat2(StyleEventSlots[2], "msgPos", StylePos1 + <0, 0.16, 0>)
		RuiSetFloat(StyleEventSlots[2], "msgAlpha", StyleEventAlpha)
		RuiSetFloat3(StyleEventSlots[2], "msgColor", SlotCols[2])
		RuiSetString(StyleEventSlots[2], "msgText", SlotStrings[2])

		RuiSetFloat2(StyleEventSlots[3], "msgPos", StylePos1 + <0, 0.19, 0>)
		RuiSetFloat(StyleEventSlots[3], "msgAlpha", StyleEventAlpha)
		RuiSetFloat3(StyleEventSlots[3], "msgColor", SlotCols[3])
		RuiSetString(StyleEventSlots[3], "msgText", SlotStrings[3])

		RuiSetFloat2(StyleEventSlots[4], "msgPos", StylePos1 + <0, 0.22, 0>)
		RuiSetFloat(StyleEventSlots[4], "msgAlpha", StyleEventAlpha)
		RuiSetFloat3(StyleEventSlots[4], "msgColor", SlotCols[4])
		RuiSetString(StyleEventSlots[4], "msgText", SlotStrings[4])

		RuiSetFloat2(StyleRankRuis[1], "msgPos", StylePos2)
		RuiSetFloat(StyleRankRuis[1], "msgFontSize", StyleScale2)
		RuiSetFloat3(StyleRankRuis[1], "msgColor", StyleCol2)
		RuiSetFloat3(StyleRankRuis[0], "msgColor", StyleCol1)
		RuiSetString(StyleRankRuis[1], "msgText", StyleRankStrings[1])
		RuiSetString(StyleRankRuis[0], "msgText", StyleRankStrings[0])

		if (StylePoints >= 16){ //Style point cap
			StylePoints = 16
		}
		StyleBarWidth = (StylePointPercenage/13.3333333333) //Percentage to width on the bar
		RuiTopology_UpdateSphereArcs(PercentageBarTopo,(COCKPIT_RUI_WIDTH * StyleBarWidth),(COCKPIT_RUI_HEIGHT * 0.017), COCKPIT_RUI_SUBDIV) //Update the bar
		if(((TimeNow - TimeSinceLast) > GetConVarFloat("EventExpiration"))){
			StyleEventAlpha = StyleEventAlpha - 0.01
			if((TimeNow - TimeSinceLast) > GetConVarFloat("EventExpiration") + 1.5){
				SlotStrings[0] = ""
				SlotStrings[1] = ""
				SlotStrings[2] = ""
				SlotStrings[3] = ""
				SlotStrings[4] = ""
				if((TimeNow - TimeSinceLast) > 6){
					Multikill = 0
				}
			}
		}
		StylePointPercenage = StylePoints
		while (StylePointPercenage > 2.0){
			StylePointPercenage = StylePointPercenage - 2.0
		}
		WaitFrame()
		if(!IsLobby()){ // Reset on death
			if(!IsAlive(GetLocalClientPlayer()))
			{
			StylePoints = 0
			StyleStreak = 0
			}
		}
		if (StylePoints > 0.001 * GetConVarFloat("DecayRate")){
			StylePoints = StylePoints - 0.001 * GetConVarFloat("DecayRate") //* sqrt(Time()-TimeSinceLast) //To make decay faster if no points are gained // Decay is now edited in modsettings
			//if(StylePoints < 0) //safeguard
			//	StylePoints = 0
		}
		else{
			StylePoints = 0
		}
	}
	RuiDestroy(StyleRankRuis[1])
	RuiDestroy(StyleRankRuis[0])
	RuiDestroy(StyleEventSlots[0])
	RuiDestroy(StyleEventSlots[1])
	RuiDestroy(StyleEventSlots[2])
	RuiDestroy(StyleEventSlots[3])
	RuiDestroy(StyleEventSlots[4])
	RuiDestroy(percentageRui)
}


void function StyleRuiSetup(){
	percentageRui = RuiCreate( $"ui/basic_image.rpak", PercentageBarTopo, RUI_DRAW_COCKPIT, 0)
	StyleRankRuis[1] = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0)
	StyleRankRuis[0] = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0)
	StyleEventSlots[0] = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0)
	StyleEventSlots[1] = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0)
	StyleEventSlots[2] = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0)
	StyleEventSlots[3] = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0)
	StyleEventSlots[4] = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0)

	//Style rank Segment 1
	RuiSetInt(StyleRankRuis[0], "maxLines", 1)
	RuiSetInt(StyleRankRuis[0], "lineNum", 1)
	RuiSetFloat2(StyleRankRuis[0], "msgPos", StylePos1)
	RuiSetFloat(StyleRankRuis[0], "msgFontSize", 70.0)
	RuiSetFloat(StyleRankRuis[0], "msgAlpha", 1.0)
	RuiSetFloat(StyleRankRuis[0], "thicken", 0.0)
	RuiSetFloat3(StyleRankRuis[0], "msgColor", StyleCol1)
	RuiSetString(StyleRankRuis[0], "msgText", StyleRankStrings[0])
	//Style rank Segment 2
	RuiSetInt(StyleRankRuis[1], "maxLines", 1)
	RuiSetInt(StyleRankRuis[1], "lineNum", 1)
	RuiSetFloat2(StyleRankRuis[1], "msgPos", StylePos2)
	RuiSetFloat(StyleRankRuis[1], "msgFontSize", StyleScale2)
	RuiSetFloat(StyleRankRuis[1], "msgAlpha", 1.0)
	RuiSetFloat(StyleRankRuis[1], "thicken", 0.0)
	RuiSetFloat3(StyleRankRuis[1], "msgColor", StyleCol2)
	RuiSetString(StyleRankRuis[1], "msgText", StyleRankStrings[1])

	//Slot 1
	RuiSetInt(StyleEventSlots[0], "maxLines", 1)
	RuiSetInt(StyleEventSlots[0], "lineNum", 1)
	RuiSetFloat2(StyleEventSlots[0], "msgPos", <StylePosX1, StylePosY1 + 1, 0>)
	RuiSetFloat(StyleEventSlots[0], "msgFontSize", 50.0)
	RuiSetFloat(StyleEventSlots[0], "msgAlpha", StyleEventAlpha)
	RuiSetFloat(StyleEventSlots[0], "thicken", 0.0)
	RuiSetFloat3(StyleEventSlots[0], "msgColor", SlotCols[0])
	RuiSetString(StyleEventSlots[0], "msgText", SlotStrings[0])
	//Slot 2
	RuiSetInt(StyleEventSlots[1], "maxLines", 1)
	RuiSetInt(StyleEventSlots[1], "lineNum", 1)
	RuiSetFloat2(StyleEventSlots[1], "msgPos", <StylePosX1, StylePosY1, 0>)
	RuiSetFloat(StyleEventSlots[1], "msgFontSize", 50.0)
	RuiSetFloat(StyleEventSlots[1], "msgAlpha", StyleEventAlpha)
	RuiSetFloat(StyleEventSlots[1], "thicken", 0.0)
	RuiSetFloat3(StyleEventSlots[1], "msgColor", SlotCols[1])
	RuiSetString(StyleEventSlots[1], "msgText", SlotStrings[1])
	//Slot 3
	RuiSetInt(StyleEventSlots[2], "maxLines", 1)
	RuiSetInt(StyleEventSlots[2], "lineNum", 1)
	RuiSetFloat2(StyleEventSlots[2], "msgPos", <StylePosX1, StylePosY1, 0>)
	RuiSetFloat(StyleEventSlots[2], "msgFontSize", 50.0)
	RuiSetFloat(StyleEventSlots[2], "msgAlpha", StyleEventAlpha)
	RuiSetFloat(StyleEventSlots[2], "thicken", 0.0)
	RuiSetFloat3(StyleEventSlots[2], "msgColor", SlotCols[2])
	RuiSetString(StyleEventSlots[2], "msgText", SlotStrings[2])
	//Slot 4
	RuiSetInt(StyleEventSlots[3], "maxLines", 1)
	RuiSetInt(StyleEventSlots[3], "lineNum", 1)
	RuiSetFloat2(StyleEventSlots[3], "msgPos", <StylePosX1, StylePosY1, 0>)
	RuiSetFloat(StyleEventSlots[3], "msgFontSize", 50.0)
	RuiSetFloat(StyleEventSlots[3], "msgAlpha", StyleEventAlpha)
	RuiSetFloat(StyleEventSlots[3], "thicken", 0.0)
	RuiSetFloat3(StyleEventSlots[3], "msgColor", SlotCols[3])
	RuiSetString(StyleEventSlots[3], "msgText", SlotStrings[3])
	//Slot 5
	RuiSetInt(StyleEventSlots[4], "maxLines", 1)
	RuiSetInt(StyleEventSlots[4], "lineNum", 1)
	RuiSetFloat2(StyleEventSlots[4], "msgPos", <StylePosX1, StylePosY1, 0>)
	RuiSetFloat(StyleEventSlots[4], "msgFontSize", 50.0)
	RuiSetFloat(StyleEventSlots[4], "msgAlpha", StyleEventAlpha)
	RuiSetFloat(StyleEventSlots[4], "thicken", 0.0)
	RuiSetFloat3(StyleEventSlots[4], "msgColor", SlotCols[4])
	RuiSetString(StyleEventSlots[4], "msgText", SlotStrings[4])
}

//Khalmee's stuff
/*
Goals:
-Speed calculation:
Every 2-3 seconds get the average speed by adding up the samples and dividing them by their amount, add that as points
Every 3 continuous cycles add movement bonus
(Some aspects came out differently, but DONE)
-Air time calculation:
If not touching the ground for 3+ seconds, give points
(Has issues, look in main loop)
-Points for AI kills
Requires modifying LocalPlayerDidDamageCallback, check if victim is not player and if you're not in replay
(TODO)
*/
array < float > SpeedBuffer //Where speed samples are stored
float LastSpeedMeasurement = 0 //Last point in time when speed was measured
float LastTimeTouchingGround = 10
float TimeToBeat = 3 //Next Air Time bonus
int movementChain = 0 //Number of consecutive speed bonuses

float function GetSpeed(entity ent){ //returns horizontal speed of an entity
	vector vel = ent.GetVelocity()
	return sqrt(vel.x * vel.x + vel.y * vel.y) * (0.274176/3) //the const is for measurement in kph
}

void function AddStyleFromSpeed(){ //Adds style points based on speed
	entity p = GetLocalClientPlayer()
	float cumsum = 0 //Cumulative sum, what else did you think it means?
	float avgSpeed = 0
	SpeedBuffer.append(GetSpeed(p)) //Add current speed to the buffer
	if(Time() - LastSpeedMeasurement > 5){ //Every N seconds, check the average and apply bonuses (adjust the time)
		foreach(SpeedSample in SpeedBuffer){ //sum up speed
			cumsum += SpeedSample
		}
		avgSpeed = cumsum/SpeedBuffer.len() //and get the average

		//These values should be tweaked, speed:
		//36, 48, 60, 72
		if(avgSpeed < 36){
			movementChain = 0
		}
		else if(avgSpeed < 48){
			AddStyleEvent("speed", 0.7, Rarity[0])
			movementChain++
		}
		else if(avgSpeed < 60){
			AddStyleEvent("great speed", 1.0, Rarity[1])
			movementChain++
		}
		else if(avgSpeed < 72){
			AddStyleEvent("superior speed", 1.3, Rarity[2])
			movementChain++
		}
		else{
			AddStyleEvent("speed demon", 1.8, Rarity[3])
			movementChain++
		}

		//Same here, movement:
		switch(movementChain){
			case 3:
				AddStyleEvent("movement chain", 1.5, Rarity[0])
				break
			case 6:
				AddStyleEvent("great movement", 2.5, Rarity[2])
				break
			default:
				if(movementChain % 3 == 0 && movementChain >= 9)
				AddStyleEvent("superior movement", 3.5, Rarity[3])
				break
		}

		SpeedBuffer.clear() //eat up the buffer
		LastSpeedMeasurement = Time()
	}
}

void function AddStyleFromAirTime(){ //Air time bonus
	entity p = GetLocalClientPlayer()
	if(!p.IsOnGround() && !IsSpectating()){ //there should be some sort of check to see if player is in control
		if(Time() - LastTimeTouchingGround > TimeToBeat){
			AddStyleEvent("Air Time", 0.6, Rarity[1])
			TimeToBeat += 3
		}
	}
	else
	{
		TimeToBeat = 3
		LastTimeTouchingGround = Time()
	}
}
//end

#endif
