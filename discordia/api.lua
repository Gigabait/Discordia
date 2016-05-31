local json = require('json')
local http = require('coro-http')
local package = require('./package')

local url = function(endpoint, ...)
	return "https://discordapp.com/api" .. string.format(endpoint, ...)
end

local API = class('API')

function API:__init(token)
	self.token = token
	self.headers = {
		['Content-Type'] = 'application/json',
		['User-Agent'] = string.format('DiscordBot (%s, %s)', package.homepage, package.version),
		['Authorization'] = token
	}
end

function API:request(method, url, body)

	local headers = {}
	for k, v in pairs(self.headers) do
		table.insert(headers, {k, v})
	end

	local encodedBody
	if body then
		encodedBody = json.encode(body)
		table.insert(headers, {'Content-Length', encodedBody:len()})
	end

	local res, data = http.request(method, url, headers, encodedBody)

	p(res)
	p()
	p(data)
	p()

end

-- GET --

function API:getChannel(channelId)
	return self:request('GET', url('/channels/%s', channelId))
end

function API:getChannelInvites(channelId)
	return self:request('GET', url('/channels/%s/invites', channelId))
end

function API:getChannelMessages(channelId)
	return self:request('GET', url('/channels/%s/messages', channelId))
end

function API:getCurrentUser()
	return self:request('GET', url('/users/@me'))
end

function API:getCurrentUserGuilds()
	return self:request('GET', url('/users/@me/guilds'))
end

function API:getGateway()
	return self:request('GET', url('/gateway'))
end

function API:getGuild(guildId)
	return self:request('GET', url('/guilds/%s', guildId))
end

function API:getGuildBans(guildId)
	return self:request('GET', url('/guilds/%s', guildId))
end

function API:getGuildChannels(guildId)
	return self:request('GET', url('/guilds/%s/channels', guildId))
end

function API:getGuildEmbed(guildId)
	return self:request('GET', url('/guilds/%s/embed', guildId))
end

function API:getGuildIntegrations(guildId)
	return self:request('GET', url('/guilds/%s/integrations', guildId))
end

function API:getGuildInvites(guildId)
	return self:request('GET', url('/guilds/%s/invites', guildId))
end

function API:getGuildMember(guildId, userId)
	return self:request('GET', url('/guilds/%s/members/%s', guildId, userId))
end

function API:getGuildPruneCount(guildId)
	return self:request('GET', url('/guilds/%s/prune', guildId))
end

function API:getGuildRoles(guildId)
	return self:request('GET', url('/guilds/%s/roles', guildId))
end

function API:getGuildVoiceRegions(guildId)
	return self:request('GET', url('/guilds/%s/regions', guildId))
end

function API:getInvite(inviteId)
	return self:request('GET', url('/invites/%s', inviteId))
end

function API:getUser(userId)
	return self:request('GET', url('/users/%s', userId))
end

function API:getCurrentUserDirectMessages()
	return self:request('GET', url('/users/@me/channels'))
end

function API:getCurrentUserConnections()
	return self:request('GET', url('/users/@me/connections'))
end

function API:getGuildMembers(guildId)
	return self:request('GET', url('/guilds/%s/members', guildId))
end

function API:getVoiceRegions()
	return self:request('GET', url('/voice/regions'))
end

function API:getUsers(userIds)
	-- GET /users
end

-- POST --

function API:acceptInvite(inviteId)
	local body = {}
	return self:request('POST', url('/invites/%s', inviteId), body)
end

function API:acknowledgeMessage(channelId, messageId)
	local body = {}
	return self:request('POST', url('/channels/%s/messages/%s/ack', channelId, messageId), body)
end

function API:beginGuildPrune(guildId, days)
	local body = {days = days}
	return self:request('POST', url('/guilds/%s/prune', guildId), body)
end

function API:bulkDeleteMessages(channelId, messageIds)
	local body = {messages = messageIds}
	return self:request('POST', url('/channels/%s/messages/bulk_delete', channelId), body)
end

function API:createChannelInvite(channelId, maxAge, maxUses, temporary, xkcdpass)
	local body = { -- all optional
		max_age = maxAge, -- seconds, default 86400 = 24 hours
		max_uses = maxUses, -- integer, default 0 = unlimited
		temporary = temporary, -- bool, default false
		xkcdpass = xkcdpass, -- bool, default false
	}
	return self:request('POST', url('/channels/%s/invites', channelId), body)
end

function API:createDirectMessageChannel(userId)
	local body = {recipient_id = userId}
	return self:request('POST', url('/users/@me/channels'), body)
end

function API:createGuild(name, regionId, icon)
	local body = {
		name = name, -- 2 to 100 chars
		region = regionId, -- just the ID
		icon -- optional, base64 128x128 jpeg
	}
	return self:request('POST', url('/guilds'), body)
end

function API:createGuildChannel(guildId, name, type, bitrate)
	local body = {
		name = name, -- 2 to 100 chars
		type = type, -- text or voice, default text, optional
		bitrate = bitrate -- 8000 to 128000, default 64000, optional
	}
	return self:request('POST', url('/guilds/%s/channels', guildId), body)
end

function API:createGuildIntegration(guildId)
	-- POST /guilds/{guild.id}/integrations
end

function API:createGuildRole(guildId)
	local body = {} -- no options on creation
	return self:request('POST', url('/guilds/%s/roles', guildId), body)
end

function API:createMessage(channelId, content, tts, nonce)
	local body = {
		content = content, -- 1 to 2000 chars, required
		nonce = nonce, -- optional
		tts = tts -- bool, optional, default false
	}
	return self:request('POST', url('/channels/%s/messages', channelId), body)
end

function API:syncGuildIntegrations(guildId, integrationId)
	local body = {}
	return self:request('POST', url('/guilds/%s/integrations/%s/sync', guildId, integrationId), body)
end

function API:triggerTypingIndicator(channelId)
	local body = {}
	return self:request('POST', url('/channels/%s/typing', channelId), body)
end

function API:uploadFile(channelId)
	-- POST /channels/{channel.id}/messages
end

-- PATCH --

function API:batchModifyGuildRoles(guildId)
	-- PATCH /guilds/{guild.id}/roles
end

function API:modifyCurrentUser()
	-- PATCH /users/@me
end

function API:modifyGuild(guildId)
	-- PATCH /guilds/{guild.id}
end

function API:modifyGuildChannel(guildId)
	-- PATCH /guilds/{guild.id}/channels
end

function API:modifyGuildEmbed(guildId)
	-- PATCH /guilds/{guild.id}/embed
end

function API:modifyGuildIntegration(guildId, integrationId)
	-- PATCH /guilds/{guild.id}/integrations/{integration.id}
end

function API:modifyGuildMember(guildId, userId)
	-- PATCH /guilds/{guild.id}/members/{user.id}
end

function API:modifyGuildRole(guildId, roleId)
	-- PATCH /guilds/{guild.id}/roles/{role.id}
end

function API:editMessage(channelId, messageId)
	-- PATCH /channels/{channel.id}/messages/{message.id}
end

-- PUT --

function API:createGuildBan(guildId, userId)
	-- PUT /guilds/{guild.id}/bans/{user.id}
end

function API:editChannelPermissions(channelId, overwriteId)
	-- PUT /channels/{channel.id}/permissions/{overwrite.id}
end

-- PUT/PATCH --

function API:modifyChannel(channelId)
	-- PUT/PATCH /channels/{channel.id}
end

-- DELETE --

function API:deleteChannelPermission(channelId, overwriteId)
	-- DELETE /channels/{channel.id}/permissions/{overwrite.id}
end

function API:deleteGuild(guildId)
	-- DELETE /guilds/{guild.id}
end

function API:deleteGuildIntegration(guildId, integrationId)
	-- DELETE /guilds/{guild.id}/integrations/{integration.id}
end

function API:deleteGuildRole(guildId, roleId)
	-- DELETE /guilds/{guild.id}/roles/{role.id}
end

function API:deleteInvite(inviteId)
	-- DELETE /invites/{invite.id}
end

function API:deleteMessage(channelId, messageId)
	-- DELETE /channels/{channel.id}/messages/{message.id}
end

function API:deleteChannel(channelId)
	-- DELETE /channels/{channel.id}
end

function API:removeGuildBan()
	-- DELETE /guilds/{guild.id}/bans/{user.id}
end

function API:removeGuildMember()
	-- DELETE /guilds/{guild.id}/members/{user.id}
end

function API:leaveGuild()
	-- DELETE /users/@me/guilds/{guild.id}
end

return API
