global function StyleMeterInit
global function AddStyleEvent


var StyleRankRui1 = null
var StyleRankRui2 = null

var StyleEventSlot1 = null
var StyleEventSlot2 = null
var StyleEventSlot3 = null
var StyleEventSlot4 = null
var StyleEventSlot5 = null
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
array < float > StyleRanks = [0.0, 0.01, 2.0, 4.0, 6.0, 8.0, 10.0]
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

array < vector > Rareity = [<0.5, 0.5, 0.5>, <1.0, 1.0, 1.0>, <0.0, 1.0, 1.0>, <1.0, 0.0, 0.0>]

void function KillEvent( ObituaryCallbackParams KillEventPerams ){
	entity player = GetLocalClientPlayer()
	if((TimeNow - TimeSinceLast) > 0.0001){ //To stop Titan kills from running the func twice, probably a better way to solve this but oh well
		if(KillEventPerams.attacker == GetLocalClientPlayer()){
			StyleStreak++
			Multikill++
			if(KillEventPerams.victim.IsTitan()){
				AddStyleEvent( "titan kill", 5.0, Rareity[1] )
				if (KillEventPerams.damageSourceId == 185){
					AddStyleEvent( "Termination", 0.2, Rareity[2] ) //Titan execution
				}
			}
			if (Multikill > 1){
				AddStyleEvent( "Multikill X" + Multikill, 1.0, Rareity[2] ) // Multikills 
			}
			if (StyleStreak == 3 ){
				AddStyleEvent( "Streak", 1.0, Rareity[1] ) //Killstreaks
			}
			else if (StyleStreak == 6){
				AddStyleEvent( "Great Streak", 1.0, Rareity[2] )							
			}
			else if (StyleStreak == 10){
				AddStyleEvent( "Untouchable", 1.0, Rareity[3] )				
			}
			if(KillEventPerams.damageSourceId == 110 || KillEventPerams.damageSourceId == 75 || KillEventPerams.damageSourceId == 237 || KillEventPerams.damageSourceId == 40 || KillEventPerams.damageSourceId == 57 || KillEventPerams.damageSourceId == 81 ){
				AddStyleEvent( "Incineration", 0.5, Rareity[0] ) //Firestar + all of scorches abilities (hopefully)
			}
			else if((KillEventPerams.victim.IsTitan()) != true){
				AddStyleEvent( "pilot kill", 2.0, Rareity[1] )
				if (KillEventPerams.damageSourceId == 126 || KillEventPerams.damageSourceId ==  135 || KillEventPerams.damageSourceId ==  119 )
				{
					AddStyleEvent( "Obliterated", 0.2, Rareity[0] ) // Cold war, Epg, Charge rifle
				}
				else if (KillEventPerams.damageSourceId == 140){
					AddStyleEvent( "Disrespect", 0.2, Rareity[0] ) // Pilot melee
				}
				else if (KillEventPerams.damageSourceId == 186){
					AddStyleEvent( "Execution", 3.0, Rareity[2] ) //Pilot execution
				}
				else if (KillEventPerams.damageSourceId == 45){
					AddStyleEvent( "Railcannoned", 0.2, Rareity[0] ) // Railgun
				}
				else if (KillEventPerams.damageSourceId == 111){
					AddStyleEvent( "Bankrupt", 3.0, Rareity[2]) //Pulse blade
				}
				}
				else if (KillEventPerams.damageSourceId == 85){
					AddStyleEvent( "Why are you even using this", 0.1, Rareity[0]) //Electric smoke nades
				}
				else if (KillEventPerams.damageSourceId == 151){
					AddStyleEvent( "sliced", 0.2, Rareity[0] ) //Ronin melee
				}
			if (KillEventPerams.damageSourceId == 44){
				AddStyleEvent( "Nuke", 4.0, Rareity[2] )//Nukelear eject
			}
			if(KillEventPerams.victim.IsTitan() && !player.IsTitan()){
				AddStyleEvent( "takedown", 2.0, Rareity[3] ) //Titan kill as pilot
			}
		}
	}
}

void function AddStyleFromDmg( float num ){
	StylePoints += (num * GetConVarFloat("StyleMultiplyer"))
}

void function OnDamage( entity player, entity victim, vector Pos, int scriptDamageType){
	AddStyleFromDmg(0.1)
	if(scriptDamageType & DF_KILLSHOT){
		if(!victim.IsPlayer()){	
			AddStyleEvent( "kill", 0.4, Rareity[0]) // Ai kills
		}
		if(scriptDamageType & DF_HEADSHOT){ // Headshot kills
			AddStyleEvent("Headshot", 0.2, Rareity[0])
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
			StyleRankStrings = ["ULTRAFALL", "ULTRAFALL"]
			StyleCol1 = <1.0, 0.8431372549, 0.0>
			StyleCol2 = <1.0, 0.4431372549, 0.0>
			StyleScale2 = 70.0
			StylePos2 = StylePos1 + <0.002, 0.002, 0>
			}
		//Refresh the Rui of the style meter
		RuiSetFloat2(StyleEventSlot1, "msgPos", StylePos1 + <0, 0.10, 0>)
		RuiSetFloat(StyleEventSlot1, "msgAlpha", StyleEventAlpha)
		RuiSetFloat3(StyleEventSlot1, "msgColor", SlotCols[0])
		RuiSetString(StyleEventSlot1, "msgText", SlotStrings[0])

		RuiSetFloat2(StyleEventSlot2, "msgPos", StylePos1 + <0, 0.13, 0>)
		RuiSetFloat(StyleEventSlot2, "msgAlpha", StyleEventAlpha)
		RuiSetFloat3(StyleEventSlot2, "msgColor", SlotCols[1])
		RuiSetString(StyleEventSlot2, "msgText", SlotStrings[1])
	
		RuiSetFloat2(StyleEventSlot3, "msgPos", StylePos1 + <0, 0.16, 0>)
		RuiSetFloat(StyleEventSlot3, "msgAlpha", StyleEventAlpha)
		RuiSetFloat3(StyleEventSlot3, "msgColor", SlotCols[2])
		RuiSetString(StyleEventSlot3, "msgText", SlotStrings[2])
	
		RuiSetFloat2(StyleEventSlot4, "msgPos", StylePos1 + <0, 0.19, 0>)
		RuiSetFloat(StyleEventSlot4, "msgAlpha", StyleEventAlpha)
		RuiSetFloat3(StyleEventSlot4, "msgColor", SlotCols[3])
		RuiSetString(StyleEventSlot4, "msgText", SlotStrings[3])
		
		RuiSetFloat2(StyleEventSlot5, "msgPos", StylePos1 + <0, 0.22, 0>)
		RuiSetFloat(StyleEventSlot5, "msgAlpha", StyleEventAlpha)
		RuiSetFloat3(StyleEventSlot5, "msgColor", SlotCols[4])
		RuiSetString(StyleEventSlot5, "msgText", SlotStrings[4])
			
		RuiSetFloat2(StyleRankRui2, "msgPos", StylePos2)
		RuiSetFloat(StyleRankRui2, "msgFontSize", StyleScale2)
		RuiSetFloat3(StyleRankRui2, "msgColor", StyleCol2)
		RuiSetFloat3(StyleRankRui1, "msgColor", StyleCol1)
		RuiSetString(StyleRankRui2, "msgText", StyleRankStrings[1])
		RuiSetString(StyleRankRui1, "msgText", StyleRankStrings[0])
		
		if (StylePoints >= 12){ //Style point cap
			StylePoints = 12
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
	RuiDestroy(StyleRankRui2)
	RuiDestroy(StyleRankRui1)
	RuiDestroy(StyleEventSlot1)
	RuiDestroy(StyleEventSlot2)
	RuiDestroy(StyleEventSlot3)
	RuiDestroy(StyleEventSlot4)
	RuiDestroy(StyleEventSlot5)
	RuiDestroy(percentageRui)
}


void function StyleRuiSetup(){ // Puting these here to make me seam more orgainsed than I am :)
	percentageRui = RuiCreate( $"ui/basic_image.rpak", PercentageBarTopo, RUI_DRAW_COCKPIT, 0)
	StyleRankRui2 = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0)
	StyleRankRui1 = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0)
	StyleEventSlot1 = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0)
	StyleEventSlot2 = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0)
	StyleEventSlot3 = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0)
	StyleEventSlot4 = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0)
	StyleEventSlot5 = RuiCreate($"ui/cockpit_console_text_top_left.rpak", clGlobal.topoCockpitHudPermanent, RUI_DRAW_COCKPIT, 0)
	
	//Style rank Segment 1
	RuiSetInt(StyleRankRui1, "maxLines", 1)
	RuiSetInt(StyleRankRui1, "lineNum", 1)	
	RuiSetFloat2(StyleRankRui1, "msgPos", StylePos1)
	RuiSetFloat(StyleRankRui1, "msgFontSize", 70.0)
	RuiSetFloat(StyleRankRui1, "msgAlpha", 1.0)	
	RuiSetFloat(StyleRankRui1, "thicken", 0.0)
	RuiSetFloat3(StyleRankRui1, "msgColor", StyleCol1)
	RuiSetString(StyleRankRui1, "msgText", StyleRankStrings[0])
	//Style rank Segment 2	
	RuiSetInt(StyleRankRui2, "maxLines", 1)
	RuiSetInt(StyleRankRui2, "lineNum", 1)
	RuiSetFloat2(StyleRankRui2, "msgPos", StylePos2)
	RuiSetFloat(StyleRankRui2, "msgFontSize", StyleScale2)
	RuiSetFloat(StyleRankRui2, "msgAlpha", 1.0)
	RuiSetFloat(StyleRankRui2, "thicken", 0.0)	
	RuiSetFloat3(StyleRankRui2, "msgColor", StyleCol2)
	RuiSetString(StyleRankRui2, "msgText", StyleRankStrings[1])

	//Slot 1
	RuiSetInt(StyleEventSlot1, "maxLines", 1)
	RuiSetInt(StyleEventSlot1, "lineNum", 1)
	RuiSetFloat2(StyleEventSlot1, "msgPos", <StylePosX1, StylePosY1 + 1, 0>)
	RuiSetFloat(StyleEventSlot1, "msgFontSize", 50.0)
	RuiSetFloat(StyleEventSlot1, "msgAlpha", StyleEventAlpha)
	RuiSetFloat(StyleEventSlot1, "thicken", 0.0)
	RuiSetFloat3(StyleEventSlot1, "msgColor", SlotCols[0])
	RuiSetString(StyleEventSlot1, "msgText", SlotStrings[0])
	//Slot 2
	RuiSetInt(StyleEventSlot2, "maxLines", 1)
	RuiSetInt(StyleEventSlot2, "lineNum", 1)
	RuiSetFloat2(StyleEventSlot2, "msgPos", <StylePosX1, StylePosY1, 0>)
	RuiSetFloat(StyleEventSlot2, "msgFontSize", 50.0)
	RuiSetFloat(StyleEventSlot2, "msgAlpha", StyleEventAlpha)
	RuiSetFloat(StyleEventSlot2, "thicken", 0.0)
	RuiSetFloat3(StyleEventSlot2, "msgColor", SlotCols[1])
	RuiSetString(StyleEventSlot2, "msgText", SlotStrings[1])
	//Slot 3	
	RuiSetInt(StyleEventSlot3, "maxLines", 1)
	RuiSetInt(StyleEventSlot3, "lineNum", 1)
	RuiSetFloat2(StyleEventSlot3, "msgPos", <StylePosX1, StylePosY1, 0>)
	RuiSetFloat(StyleEventSlot3, "msgFontSize", 50.0)
	RuiSetFloat(StyleEventSlot3, "msgAlpha", StyleEventAlpha)
	RuiSetFloat(StyleEventSlot3, "thicken", 0.0)
	RuiSetFloat3(StyleEventSlot3, "msgColor", SlotCols[2])
	RuiSetString(StyleEventSlot3, "msgText", SlotStrings[2])
	//Slot 4	
	RuiSetInt(StyleEventSlot4, "maxLines", 1)
	RuiSetInt(StyleEventSlot4, "lineNum", 1)
	RuiSetFloat2(StyleEventSlot4, "msgPos", <StylePosX1, StylePosY1, 0>)
	RuiSetFloat(StyleEventSlot4, "msgFontSize", 50.0)
	RuiSetFloat(StyleEventSlot4, "msgAlpha", StyleEventAlpha)
	RuiSetFloat(StyleEventSlot4, "thicken", 0.0)
	RuiSetFloat3(StyleEventSlot4, "msgColor", SlotCols[3])
	RuiSetString(StyleEventSlot4, "msgText", SlotStrings[3])
	//Slot 5
	RuiSetInt(StyleEventSlot5, "maxLines", 1)
	RuiSetInt(StyleEventSlot5, "lineNum", 1)
	RuiSetFloat2(StyleEventSlot5, "msgPos", <StylePosX1, StylePosY1, 0>)
	RuiSetFloat(StyleEventSlot5, "msgFontSize", 50.0)
	RuiSetFloat(StyleEventSlot5, "msgAlpha", StyleEventAlpha)
	RuiSetFloat(StyleEventSlot5, "thicken", 0.0)
	RuiSetFloat3(StyleEventSlot5, "msgColor", SlotCols[4])
	RuiSetString(StyleEventSlot5, "msgText", SlotStrings[4])
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
			AddStyleEvent("speed", 0.7, Rareity[0])
			movementChain++
		}
		else if(avgSpeed < 60){
			AddStyleEvent("great speed", 1.0, Rareity[1])
			movementChain++
		}
		else if(avgSpeed < 72){
			AddStyleEvent("superior speed", 1.3, Rareity[2])
			movementChain++
		}
		else{
			AddStyleEvent("speed demon", 1.8, Rareity[3])
			movementChain++
		}

		//Same here, movement:
		switch(movementChain){
			case 3:
				AddStyleEvent("movement chain", 1.5, Rareity[0])
				break
			case 6:
				AddStyleEvent("great movement", 2.5, Rareity[2])
				break
			default:
				if(movementChain % 3 == 0 && movementChain >= 9)
				AddStyleEvent("superior movement", 3.5, Rareity[3])
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
			AddStyleEvent("Air Time", 0.6, Rareity[1])
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
