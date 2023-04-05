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
	topology = RuiTopology_CreateSphere(COCKPIT_RUI_OFFSET - <0, 82, -21>, <0, -1, 0.037>, <0, 0.00, -1>, COCKPIT_RUI_RADIUS, COCKPIT_RUI_WIDTH * 0.15, COCKPIT_RUI_HEIGHT * 0.003, 3.5)
	entity player = GetLocalClientPlayer()
	AddLocalPlayerDidDamageCallback(OnDamage)
	PercentageBarTopo = topology	
	AddCallback_OnPlayerKilled(KillEvent)
	StyleRuiSetup()
	thread UpdateRankUI()
	TimeSinceLast = Time()
}

bool OnCooldown = false
float damadgeAmount = 0.0
float StyleBarWidth = 0.15
int StyleStreak = 0
int Multikill = 0
string mostRecentModifier = ""
bool Slot1Full = false
int PlayerStreak = 0
#if CLIENT
float TimeSinceLast = 0
float TimeNow = 0
float StylePoints = 0.0
float StyleEventAlpha = 1.0
float Nrank = 0.0
float Drank = 0.01
float Crank = 2.0
float Brank = 4.0
float Arank = 6.0
float Srank = 8.0
float Prank = 10.0
float StylePosX1 = 0.8
float StylePosY1 = 0.2
string Slot1 = ""
string Slot2 = ""
string Slot3 = ""
string Slot4 = ""
string Slot5 = ""
vector Slot1Col = <0.5, 0.5, 0.5>
vector Slot2Col = <0.5, 0.5, 0.5>
vector Slot3Col = <0.5, 0.5, 0.5>
vector Slot4Col = <0.5, 0.5, 0.5>
vector Slot5Col = <0.5, 0.5, 0.5>
string StyleRank1 = ""
string StyleRank2 = ""
vector StyleCol1 = <1.0, 1.0, 1.0>
vector StyleCol2 = <1.0, 1.0, 1.0>
vector PercentageCol = <1.0, 1.0, 1.0>
float StylePosX2 = (0.9 + 0.02)
float StylePosY2 = (0.2 + 0.03)
float StyleScale2 = 50.0
float StylePointPercenage = 0.0

vector Rareity1 = <0.5, 0.5, 0.5>
vector Rareity2 = <1.0, 1.0, 1.0>
vector Rareity3 = <0.0, 1.0, 1.0>
vector Rareity4 = <1.0, 0.0, 0.0>

void function KillEvent( entity victim, entity attacker, int damageSourceId ){
	entity player = GetLocalClientPlayer()
	if((TimeNow - TimeSinceLast) > 0.0001){ //To stop Titan kills from running the func twice, probably a better way to solve this but oh well
		if(attacker == GetLocalClientPlayer()){
			TimeSinceLast = Time()
			StyleStreak++
			Multikill++
			if(victim.IsTitan()){
				AddStyleEvent( "titan kill", 5.0, Rareity2 )
				if (damageSourceId == 185){
					AddStyleEvent( "Termination", 0.2, Rareity3 ) //Titan execution
				}
			}
			if (Multikill > 1){
				AddStyleEvent( "Multikill X" + Multikill, 1.0, Rareity3 ) // Multikills 
			}
			if (StyleStreak == 3 ){
				AddStyleEvent( "Streak", 1.0, Rareity2 ) //Killstreaks
			}
			else if (StyleStreak == 6){
				AddStyleEvent( "Great Streak", 1.0, Rareity3 )							
			}
			else if (StyleStreak == 10){
				AddStyleEvent( "Untouchable", 1.0, Rareity4 )				
			}
			if(damageSourceId == 110 || damageSourceId == 75 || damageSourceId == 237 || damageSourceId == 40 || damageSourceId == 57 || damageSourceId == 81 ){
				AddStyleEvent( "Incineration", 0.5, Rareity1 ) //Firestar + all of scorches abilities (hopefully)
			}
			else if(!victim.IsTitan()){
				AddStyleEvent( "pilot kill", 2.0, Rareity2 )
				if ( damageSourceId == 126 || damageSourceId ==  135 || damageSourceId ==  119 )
				{
					AddStyleEvent( "Obliterated", 0.2, Rareity1 ) // Cold war, Epg, Charge rifle
				}
				else if (damageSourceId == 140){
					AddStyleEvent( "Disrespect", 0.2, Rareity1 ) // Pilot melee
				}
				else if (damageSourceId == 186){
					AddStyleEvent( "Execution", 3.0, Rareity3 ) //Pilot execution
				}
				else if (damageSourceId == 45){
					AddStyleEvent( "Railcannoned", 0.2, Rareity1 ) // Railgun
				}
				else if (damageSourceId == 111){
					AddStyleEvent( "Bankrupt", 3.0, Rareity3) //Pulse blade
				}
				}
				else if (damageSourceId == 85){
					AddStyleEvent( "Why are you even using this", 0.1, Rareity1) //Electric smoke nades
				}
				else if (damageSourceId == 151){
					AddStyleEvent( "sliced", 0.2, Rareity1 ) //Ronin melee
				}
			if (damageSourceId == 44){
				AddStyleEvent( "Nuke", 4.0, Rareity3 )//Nukelear eject
			}
			if(victim.IsTitan() && !player.IsTitan()){
				AddStyleEvent( "takedown", 2.0, Rareity4 ) //Titan kill as pilot
			}
		}
	}
}

void function AddStyleFromDmg( float num ){
	StylePoints += num
}

void function OnDamage( entity player, entity victim, vector Pos, int DamageType ){
	AddStyleFromDmg(0.1)
}

void function AddStyleEvent( string name, float amount, vector rarity ){
	StylePoints = StylePoints + amount
	if (Slot1Full == false){
		Slot1 = ("+" + name)
		Slot1Col = rarity
		Slot1Full = true
		StyleEventAlpha = 1.0
		TimeSinceLast = Time()
	}
	else {	//A really bad way to move the events down one slot if Slot1 is full
		Slot5 = Slot4
		Slot5Col = Slot4Col
		Slot4 = Slot3
		Slot4Col = Slot3Col
		Slot3 = Slot2
		Slot3Col = Slot2Col
		Slot2 = Slot1
		Slot2Col = Slot1Col
		Slot1 = ("+" + name)
		Slot1Col = rarity
		TimeSinceLast = Time()
		StyleEventAlpha = 1.0
	}
}
  

void function UpdateRankUI(){
	while(true){
		TimeNow = Time()
		StylePosX2 = StylePosX1 + 0.02
		StylePosY2 = StylePosY1 + 0.03
		StyleScale2 = 50.0
		if (StylePoints == Nrank){
			StyleRank1 = ""
			StyleRank2 = ""
			StyleCol1 = <1.0, 1.0, 1.0>
		}
		if (StylePoints > Drank){
			StyleRank1 = "D"
			StyleRank2 = "estructive"
			StyleCol1 = <0.0, 0.58039215686, 1.0>
			StyleCol2 = <1.0, 1.0, 1.0>
		}
		if (StylePoints > Crank){
			StyleRank1 = "C"
			StyleRank2 = "haotic"
			StyleCol1 = <0.31372549019, 0.98823529411, 0.0156862745>
			StyleCol2 = <1.0, 1.0, 1.0>
		}
		if (StylePoints > Brank){
			StyleRank1 = "B"
			StyleRank2 = "rutal"
			StyleCol1 = <0.98823529411, 0.83137254902, 0.0156862745>
			StyleCol2 = <1.0, 1.0, 1.0>
		}
		if (StylePoints > Arank){
			StyleRank1 = "A"
			StyleRank2 = "narchic"
			StyleCol1 = <1.0, 0.42352941176, 0.0156862745>
			StyleCol2 = <1.0, 1.0, 1.0>
		}
		if (StylePoints > Srank){
			StyleRank1 = "S"
			StyleRank2 = "upreme"
			StyleCol1 = <1.0, 0.0156862745, 0.0156862745>
			StyleCol2 = <1.0, 1.0, 1.0>
		}
		if (StylePoints > Prank){
			StyleRank1 = "ULTRAFALL"
			StyleRank2 = "ULTRAFALL"
			StyleCol1 = <1.0, 0.8431372549, 0.0>
			StyleCol2 = <1.0, 0.4431372549, 0.0>
			StyleScale2 = 70.0
			StylePosX2 = StylePosX1 + 0.002
			StylePosY2 = StylePosY1 + 0.002
		}
		//Refresh the Rui of the style meter
		RuiSetFloat2(StyleEventSlot1, "msgPos", <StylePosX1, StylePosY1 + 0.10, 0>)
		RuiSetFloat(StyleEventSlot1, "msgAlpha", StyleEventAlpha)
		RuiSetFloat3(StyleEventSlot1, "msgColor", Slot1Col)
		RuiSetString(StyleEventSlot1, "msgText", Slot1)
	
		RuiSetFloat2(StyleEventSlot2, "msgPos", <StylePosX1, StylePosY1 + 0.13, 0>)
		RuiSetFloat(StyleEventSlot2, "msgAlpha", StyleEventAlpha)
		RuiSetFloat3(StyleEventSlot2, "msgColor", Slot2Col)
		RuiSetString(StyleEventSlot2, "msgText", Slot2)
	
		RuiSetFloat2(StyleEventSlot3, "msgPos", <StylePosX1, StylePosY1 + 0.16, 0>)
		RuiSetFloat(StyleEventSlot3, "msgAlpha", StyleEventAlpha)
		RuiSetFloat3(StyleEventSlot3, "msgColor", Slot3Col)
		RuiSetString(StyleEventSlot3, "msgText", Slot3)
	
		RuiSetFloat2(StyleEventSlot4, "msgPos", <StylePosX1, StylePosY1 + 0.19, 0>)
		RuiSetFloat(StyleEventSlot4, "msgAlpha", StyleEventAlpha)
		RuiSetFloat3(StyleEventSlot4, "msgColor", Slot4Col)
		RuiSetString(StyleEventSlot4, "msgText", Slot4)
		
		RuiSetFloat2(StyleEventSlot5, "msgPos", <StylePosX1, StylePosY1 + 0.22, 0>)
		RuiSetFloat(StyleEventSlot5, "msgAlpha", StyleEventAlpha)
		RuiSetFloat3(StyleEventSlot5, "msgColor", Slot5Col)
		RuiSetString(StyleEventSlot5, "msgText", Slot5)
			
		RuiSetFloat2(StyleRankRui2, "msgPos", <StylePosX2, StylePosY2, 0>)
		RuiSetFloat(StyleRankRui2, "msgFontSize", StyleScale2)
		RuiSetFloat3(StyleRankRui2, "msgColor", StyleCol2)
		RuiSetFloat3(StyleRankRui1, "msgColor", StyleCol1)
		RuiSetString(StyleRankRui2, "msgText", StyleRank2)
		RuiSetString(StyleRankRui1, "msgText", StyleRank1)
		
		if (StylePoints >= 12){ //Style point cap
			StylePoints = 12
		}
		StyleBarWidth = (StylePointPercenage/13.3333333333) //Percentage to width on the bar
		RuiTopology_UpdateSphereArcs(PercentageBarTopo,(COCKPIT_RUI_WIDTH * StyleBarWidth),(COCKPIT_RUI_HEIGHT * 0.017), COCKPIT_RUI_SUBDIV) //Update the bar
		if(((TimeNow - TimeSinceLast) > 5)){
			StyleEventAlpha = StyleEventAlpha - 0.01
			if((TimeNow - TimeSinceLast) > 7){
				Slot1 = ""
				Slot2 = ""
				Slot3 = ""
				Slot4 = ""
				Slot4 = ""
				Multikill = 0
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
		if (StylePoints > 0.005){
			StylePoints = StylePoints - 0.001
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
	RuiSetFloat2(StyleRankRui1, "msgPos", <StylePosX1, StylePosY1, 0>)
	RuiSetFloat(StyleRankRui1, "msgFontSize", 70.0)
	RuiSetFloat(StyleRankRui1, "msgAlpha", 1.0)	
	RuiSetFloat(StyleRankRui1, "thicken", 0.0)
	RuiSetFloat3(StyleRankRui1, "msgColor", StyleCol1)
	RuiSetString(StyleRankRui1, "msgText", StyleRank1)
	//Style rank Segment 2	
	RuiSetInt(StyleRankRui2, "maxLines", 1)
	RuiSetInt(StyleRankRui2, "lineNum", 1)
	RuiSetFloat2(StyleRankRui2, "msgPos", <StylePosX2, StylePosY2, 0>)
	RuiSetFloat(StyleRankRui2, "msgFontSize", StyleScale2)
	RuiSetFloat(StyleRankRui2, "msgAlpha", 1.0)
	RuiSetFloat(StyleRankRui2, "thicken", 0.0)	
	RuiSetFloat3(StyleRankRui2, "msgColor", StyleCol2)
	RuiSetString(StyleRankRui2, "msgText", StyleRank2)

	//Slot 1
	RuiSetInt(StyleEventSlot1, "maxLines", 1)
	RuiSetInt(StyleEventSlot1, "lineNum", 1)
	RuiSetFloat2(StyleEventSlot1, "msgPos", <StylePosX1, StylePosY1 + 1, 0>)
	RuiSetFloat(StyleEventSlot1, "msgFontSize", 50.0)
	RuiSetFloat(StyleEventSlot1, "msgAlpha", StyleEventAlpha)
	RuiSetFloat(StyleEventSlot1, "thicken", 0.0)
	RuiSetFloat3(StyleEventSlot1, "msgColor", <0.5, 0.5, 0.5>)
	RuiSetString(StyleEventSlot1, "msgText", Slot1)
	//Slot 2
	RuiSetInt(StyleEventSlot2, "maxLines", 1)
	RuiSetInt(StyleEventSlot2, "lineNum", 1)
	RuiSetFloat2(StyleEventSlot2, "msgPos", <StylePosX1, StylePosY1, 0>)
	RuiSetFloat(StyleEventSlot2, "msgFontSize", 50.0)
	RuiSetFloat(StyleEventSlot2, "msgAlpha", StyleEventAlpha)
	RuiSetFloat(StyleEventSlot2, "thicken", 0.0)
	RuiSetFloat3(StyleEventSlot2, "msgColor", <0.5, 0.5, 0.5>)
	RuiSetString(StyleEventSlot2, "msgText", Slot2)
	//Slot 3	
	RuiSetInt(StyleEventSlot3, "maxLines", 1)
	RuiSetInt(StyleEventSlot3, "lineNum", 1)
	RuiSetFloat2(StyleEventSlot3, "msgPos", <StylePosX1, StylePosY1, 0>)
	RuiSetFloat(StyleEventSlot3, "msgFontSize", 50.0)
	RuiSetFloat(StyleEventSlot3, "msgAlpha", StyleEventAlpha)
	RuiSetFloat(StyleEventSlot3, "thicken", 0.0)
	RuiSetFloat3(StyleEventSlot3, "msgColor", <0.5, 0.5, 0.5>)
	RuiSetString(StyleEventSlot3, "msgText", Slot3)
	//Slot 4	
	RuiSetInt(StyleEventSlot4, "maxLines", 1)
	RuiSetInt(StyleEventSlot4, "lineNum", 1)
	RuiSetFloat2(StyleEventSlot4, "msgPos", <StylePosX1, StylePosY1, 0>)
	RuiSetFloat(StyleEventSlot4, "msgFontSize", 50.0)
	RuiSetFloat(StyleEventSlot4, "msgAlpha", StyleEventAlpha)
	RuiSetFloat(StyleEventSlot4, "thicken", 0.0)
	RuiSetFloat3(StyleEventSlot4, "msgColor", <0.5, 0.5, 0.5>)
	RuiSetString(StyleEventSlot4, "msgText", Slot4)
	//Slot 5
	RuiSetInt(StyleEventSlot5, "maxLines", 1)
	RuiSetInt(StyleEventSlot5, "lineNum", 1)
	RuiSetFloat2(StyleEventSlot5, "msgPos", <StylePosX1, StylePosY1, 0>)
	RuiSetFloat(StyleEventSlot5, "msgFontSize", 50.0)
	RuiSetFloat(StyleEventSlot5, "msgAlpha", StyleEventAlpha)
	RuiSetFloat(StyleEventSlot5, "thicken", 0.0)
	RuiSetFloat3(StyleEventSlot5, "msgColor", <0.5, 0.5, 0.5>)
	RuiSetString(StyleEventSlot5, "msgText", Slot5)
}

#endif
