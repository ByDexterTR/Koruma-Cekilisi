#include <sourcemod>
#include <cstrike>
#include <warden>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo = 
{
	name = "Koruma Çekiliş", 
	author = "ByDexter", 
	description = "", 
	version = "1.0", 
	url = "https://steamcommunity.com/id/ByDexterTR - ByDexter#5494"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_korumacek", Command_Korumacek);
}

public Action Command_Korumacek(int client, int args)
{
	if (warden_iswarden(client))
	{
		int Koruma = GetRandomPlayer(CS_TEAM_T, false);
		PrintToChatAll("[SM] \x01Çıkan şanslı isim: \x10%N", Koruma);
		Menu menu = new Menu(Menu_Callback);
		menu.SetTitle("Koruma olmak istiyor musun?\n ");
		menu.AddItem("0", "-> Evet <-");
		menu.AddItem("1", "-> Hayır <-");
		menu.ExitBackButton = false;
		menu.ExitButton = false;
		menu.Display(Koruma, 0);
		return Plugin_Handled;
	}
	else
	{
		ReplyToCommand(client, "[SM] Bu komutu sadece komutçu kullanabilir!");
		return Plugin_Handled;
	}
}
public int Menu_Callback(Menu menu, MenuAction action, int param1, int param2)
{
	if (action == MenuAction_Select)
	{
		char Item[8];
		menu.GetItem(param2, Item, sizeof(Item));
		if (StringToInt(Item) == 0)
		{
			ChangeClientTeam(param1, CS_TEAM_CT);
			PrintToChatAll("[SM] \x10%N \x01CT olmak \x06istedi!", param1);
		}
		else
		{
			PrintToChatAll("[SM] \x10%N \x01CT olmak \x07istemedi!", param1);
		}
	}
	else if (action == MenuAction_End)
	{
		delete menu;
	}
}

stock int GetRandomPlayer(int team = -1, bool OnlyAlive = true)
{
	int[] clients = new int[MaxClients];
	int clientCount;
	for (int i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i) && (team == -1 || GetClientTeam(i) == team) && (!OnlyAlive || !IsPlayerAlive(i)))
		{
			clients[clientCount++] = i;
		}
	}
	return (clientCount == 0) ? -1 : clients[GetRandomInt(0, clientCount - 1)];
} 