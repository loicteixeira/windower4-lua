-- Copyright (c) 2013, Cairthenn-- All rights reserved.-- Redistribution and use in source and binary forms, with or without-- modification, are permitted provided that the following conditions are met:    -- * Redistributions of source code must retain the above copyright      -- notice, this list of conditions and the following disclaimer.    -- * Redistributions in binary form must reproduce the above copyright      -- notice, this list of conditions and the following disclaimer in the      -- documentation and/or other materials provided with the distribution.    -- * Neither the name of DressUp nor the      -- names of its contributors may be used to endorse or promote products      -- derived from this software without specific prior written permission.-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED-- WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE-- DISCLAIMED. IN NO EVENT SHALL Cairthenn BE LIABLE FOR ANY-- DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES-- (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;-- LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND-- ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT-- (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS-- SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.function get_item_id(str,slot)	local item_result = false		if T{"none"}:contains(str) then		return "None"	else			for k,v in pairs(models[slot]) do			if v['enl'] == str or v['name'] == str then				item_result = k			end		end		if item_result then 			return tonumber(item_result)		else			return false		end	endend--Returns rotated bytes of integers. Altered to support slot names.function Int2LE(num,number_of_bytes)	these_bytes = ''	if num == "RandomModel" then		num = random_gear(number_of_bytes:lower())	end	if not num then		num = 0	end	if T{"Race","Face"}:contains(number_of_bytes) then		number_of_bytes = 1	elseif T{"Head","Body","Hands","Legs","Feet","Sub","Main","Ranged"}:contains(number_of_bytes) then		number_of_bytes = 2	else		number_of_bytes = number_of_bytes or 4	end	for i=1,number_of_bytes do		these_bytes = these_bytes..string.char(num%256)		num = math.floor(num/256)	end	return these_bytesendfunction random_gear(slot)	local choice = keyset[slot][math.random(1,#keyset[slot])]		if tonumber(models[slot][choice]["model"]) then		return tonumber(models[slot][choice]["model"])	else random_gear(slot) end	end--Creates array of party IDs to check against blink logicfunction make_party_ids()	party_member_list = {}	for k,v in pairs(get_party()) do		if v["mob"] then			if windower.wc_match(k, 'p?|a?') then				table.append(party_member_list,v["mob"].id)			end		end	end	return party_member_listend-- Reinstates model blockingfunction FinishedZone()	zone_reset = falseendfunction do_blink_logic(selection,c_index)	if selection == "self_special" then		if settings.blinking["self"]["always"] or (settings.blinking["follow"]["always"] and get_player().follow_index) or 		settings.blinking["all"]["always"] or (settings.blinking["all"]["combat"] and get_player().in_combat) or		((settings.blinking["self"]["target"] or settings.blinking["all"]["target"]) and (get_player().target_index == get_player().index)) then			return true		else			return false		end	elseif selection == "always" then		return true	elseif selection == "combat" then		if get_player().in_combat then			return true		else			return false		end	elseif selection == "follow" then		if c_index == get_player().target_index then			return true		else			return false		end	endendfunction print_blink_settings(option)	print('DressUp (v'.._addon.version..') Blink Prevention Settings') 	if option == "global" or option == "all" then	print(('All:    '):text_color(255,255,255)..table.concat(map(settings.blinking["all"],formatting)," "))	end	if option == "global" or option == "self" then	print(('Self:   '):text_color(255,255,255)..table.concat(map(settings.blinking["self"],formatting)," "))	end	if option == "global" or option == "others" then	print(('Others: '):text_color(255,255,255)..table.concat(map(settings.blinking["others"],formatting)," "))	end	if option == "global" or option == "party" then	print(('Party:  '):text_color(255,255,255)..table.concat(map(settings.blinking["party"],formatting)," "))	end	if option == "global" or option == "follow" then	print(('Follow: '):text_color(255,255,255)..table.concat(map(settings.blinking["follow"],formatting)," "))	endend--The following two are used in the formatting of blink rules into strings.function map(t, func)  local out = {}  for k,v in pairs(t) do    out[k] = func(k, v)  end  return outendfunction formatting(k, v) 	v = tostring(v):gsub("^%l", string.upper)	if windower.wc_match(v,"True") then		v = ('T'):text_color(0, 255, 0)	else		v = 'F'	end  return k:gsub("^%l", string.upper) ..': ['..v..']' end