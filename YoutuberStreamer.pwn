/*
		Youtuber & Streamer Tag
		Kodlayan: abatay

*/
#pragma compat 1
#include <a_samp>
#include <zcmd>
#include <sscanf2>
new bool:YoutuberStreamer[MAX_PLAYERS];
new bool:YTDuty[MAX_PLAYERS];
new Text3D:YTLabel[MAX_PLAYERS];
#define YT_CHAT 0 // 1: Oyuncu chata birþey yazdýðýnda baþýnda Youtuber & Streamer tagý olur 0: Bir þey olmaz.
public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Youtuber & Streamer sistemi yüklenmiþtir. Kodlayan: abatay");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	YoutuberStreamer[playerid] = false;
	YTDuty[playerid] = false;
	new file[60];
	format(file, sizeof(file), "YoutuberStreamer/%s.txt", getName(playerid));
	if(fexist(file))
	{
	    YoutuberStreamer[playerid] = true;
	    YTDuty[playerid] = false;
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    YoutuberStreamer[playerid] = false;
	YTDuty[playerid] = false;
	Delete3DTextLabel(YTLabel[playerid]);
	return 1;
}

public OnPlayerText(playerid, text[])
{
	if(YTDuty[playerid] == true && YT_CHAT == 1)
	{
	    new str[200];
		format(str, sizeof(str), "{FF0000}[Youtuber & Streamer] {%06x}%s(%i): {FFFFFF}%s", GetPlayerColor(playerid) >>> 8, getName(playerid),playerid, text);
		SendClientMessageToAll(-1, str);
		return 0;
	}
	return 1;
}
CMD:ytag(playerid, params[])
{
	new id;
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, -1, "{FF0000}[!]: {FFFFFF}Bu komutu kullanabilmek için RCON olmalýsýnýz.");
	if(sscanf(params, "u", id)) return SendClientMessage(playerid, -1, "{0097F5}[!]: {FFFFFF}/ytag [ID/Isim]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{FF0000}[!]: Oyuncu oyunda deðil!");
	new str[124];
	if(YoutuberStreamer[id] == true)
	{
	    YoutuberStreamer[id] = false;
	    YTDuty[id] = false;
	    Delete3DTextLabel(YTLabel[id]);
	    format(str, sizeof(str), "YoutuberStreamer/%s.txt", getName(id));
	    if(fexist(str)) fremove(str);
	    format(str, sizeof(str), "{0097F5}[!]: {FFFFFF}%s adlý yetkili tarafýndan Youtuber & Streamer tagýnýz silindi.", getName(playerid));
	    SendClientMessage(id, -1, str);
	    format(str, sizeof(str), "{0097F5}[!]: {FFFFFF}%s adlý kiþinin Youtuber & Streamer tagýný sildiniz.", getName(id));
	    SendClientMessage(playerid, -1, str);
	}
	else
	{
	    YoutuberStreamer[id] = true;
	    YTDuty[id] = false;
	    Delete3DTextLabel(YTLabel[id]);
	    format(str, sizeof(str), "YoutuberStreamer/%s.txt", getName(id));
	    if(!fexist(str)) fcreate(str);
	    format(str, sizeof(str), "{0097F5}[!]: {FFFFFF}%s adlý yetkili size Youtuber tagý verdi (/yduty ile aktif edebilirsiniz).", getName(playerid));
	    SendClientMessage(id, -1, str);
	    format(str, sizeof(str), "{0097F5}[!]: {FFFFFF}%s adlý kiþiye Youtuber tagý verdiniz.", getName(id));
	    SendClientMessage(playerid, -1, str);
	}
	return 1;
}
CMD:yduty(playerid)
{
	if(!IsPlayerSpawned(playerid)) return SendClientMessage(playerid, -1, "{FF0000}[!]: {FFFFFF}Spawn olmadan komut kullanamazsýnýz.");
	if(YoutuberStreamer[playerid] == false) return SendClientMessage(playerid, -1, "{FF0000}[!]: {FFFFFF}Yetkiniz yok.");
	if(YTDuty[playerid] == false)
	{
	    YTDuty[playerid] = true;
	    YTLabel[playerid] = Create3DTextLabel("Youtuber & Streamer", 0xFF0000FF, 0.0, 0.0, 0.0, 6.0, -1, 1);
	    Attach3DTextLabelToPlayer(YTLabel[playerid], playerid, 0.0, 0.0, 0.4);
	    SendClientMessage(playerid, -1, "{0097F5}[!]: {FFFFFF}Youtuber & Streamer tagýnýz {00FF4C}aktif.");
	}
	else
	{
	    YTDuty[playerid] = false;
	    Delete3DTextLabel(YTLabel[playerid]);
	    SendClientMessage(playerid, -1, "{0097F5}[!]: {FFFFFF}Youtuber & Streamer tagýnýz {FF0000}deaktif.");
	}
	return 1;
}
CMD:ychat(playerid, params[])
{
	new msj[70], str[150];
    if(YoutuberStreamer[playerid] == false) return SendClientMessage(playerid, -1, "{FF0000}[!]: {FFFFFF}Yetkiniz yok.");
    if(sscanf(params, "s[70]", msj)) return SendClientMessage(playerid, -1, "{0097F5}[!]: {FFFFFF}/ychat [Mesaj]");
    format(str, sizeof(str), "{0095FF}[Y-CHAT] %s(%d): {FFFFFF}%s", getName(playerid), playerid, msj);
	for(new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
	    if(IsPlayerConnected(i) && YoutuberStreamer[i] == true)
	    {
	        SendClientMessage(i, -1, str);
	    }
	}
	return 1;
}
IsPlayerSpawned(playerid)
{
	new pState = GetPlayerState(playerid);

	return 0 <= playerid <= MAX_PLAYERS && pState != PLAYER_STATE_NONE && pState != PLAYER_STATE_WASTED && pState != PLAYER_STATE_SPECTATING;
}
getName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid, name, sizeof(name));
	return name;
}
fcreate(filename[])
{
    if(fexist(filename)) return 0;
    new File:file = fopen(filename, io_write);
    fclose(file);
    return 1;
}
