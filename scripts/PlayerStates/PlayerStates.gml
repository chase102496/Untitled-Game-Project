function scrPlayerStateInit()
{
	#region Networking states, for online play
	
	netState.add("Online",{
		enter: function()
		{
			global.connected = false;
			global.host = false;
			halfpack = -1; // if a packet is split in half, we use this
			
			// --- This is when the connection is created
			socket = network_create_socket(network_socket_tcp);
			
			// Async = Don't crash the game if the server is down
			network_connect_raw_async(socket, IP, real(PORT));
		},
		async: function()
		{
			// --- This is when we receive any packet
			var type = async_load[? "type"]
			var buff = async_load[? "buffer"]

			switch(type) {
				case network_type_data:
				{
					// if this is the second half of a packet
					if (buffer_exists(halfpack)) {
						var new_buff = buffer_create(1, buffer_grow, 1);
						buffer_copy(halfpack, 0, buffer_get_size(halfpack), new_buff, 0);
						buffer_copy(buff, 0, buffer_get_size(buff), new_buff, buffer_get_size(new_buff));
			
						buffer_delete(buff);
						buff = new_buff;
			
						buffer_delete(halfpack);
						halfpack = -1;
			
						trace("-half out")
					}
		
					//var size = async_load[? "size"]
					var size = buffer_get_size(buff)
					var pack_count = 0
		
					//trace("global pack size: %", size)
		
					for(var i = 0; i < size;) { // Break up the binary blob into single packets
						// Read the packet size
						var packSize = buffer_peek(buff, i, buffer_u16); // this also seeks
			
						if (i + packSize > size) {
							halfpack = buffer_create(1, buffer_grow, 1);
							buffer_copy(buff, i, i + 2 + packSize, halfpack, 0);
							trace("half in-")
							break;
						}
						i += 2;
			
						// Read the packet contents
						var pack = buffer_create(1, buffer_grow, 1);
						buffer_copy(buff, i, packSize, pack, 0);
			
						i += packSize;
			
						try 
						{
							// Handle the packet
							handlePacket(pack);
						}
						catch(e) 
						{
							trace("an error occured while parsing the packet: " + e.message)
						}
			
						pack_count++;
			
						// Clean up
						buffer_delete(pack);
					}
		
					//trace("packet_count: %", pack_count);
		
					buffer_delete(buff);
		
					//trace("Packs received: %", pack_count);
					break;
				}
					
				case network_type_non_blocking_connect:
				{
				}
					
				case network_type_connect:
				{
					netSendConnect();
					break;
				}
				
				case network_type_disconnect:
				{
					netSendDisconnect();
					break;
				}
			}
		},
		step: function()
		{
			if global.connected
			{
				//Finding host, first joiner
				global.host = (netGetHost() == global.clientDataSelf.clientID);
				
				//Syncing our data, if we're the host
				if global.host
				{
					for (var i = 0;i < array_length(global.localInstances);i ++)
					{
						with global.localInstances[i]
						{
							if object_is_ancestor(object_index,parEntity) netSyncVariablesTo(["x","y","layer","stats","netObject","sprite_index","image_index","image_angle","image_alpha"]);
							if object_index == objEquip netSyncVariablesTo(["x","y","layer","stats","netObject","sprite_index","image_index_actual","image_xscale","image_yscale","image_angle","image_alpha","spriteFrame"]);
							else if object_index == objProjectile netSyncVariablesTo(["x","y","sprite_index","image_speed","image_index","image_angle","image_alpha","layer","stats","netObject"]);
						}
					}
				}
				else
				{
					for (var i = 0;i < array_length(global.localInstances);i ++)
					{
						with global.localInstances[i]
						{
							switch (object_index)
							{
								case objPlayer:
									netSyncVariablesTo(["x","y","layer","stats","netObject","sprite_index","image_index","image_angle","image_alpha"]);
									break;
								
								case objEquip:
									if owner == global.inputObject netSyncVariablesTo(["x","y","layer","stats","netObject","sprite_index","image_index_actual","image_xscale","image_yscale","image_angle","image_alpha","spriteFrame"]);
									break;
								
								case objProjectile:
									if owner == global.inputObject netSyncVariablesTo(["x","y","sprite_index","image_speed","image_index","image_angle","image_alpha","layer","stats","netObject"]);
									break;
									
								default:
									instance_destroy();
									break;
							}
						}
					}
				}
				
				//Push our data to the server object, and pull every other client's data
				send({cmd: "netSyncClientInfoSelf", dataSelf: json_stringify(global.clientDataSelf)});
				send({cmd: "netGetClientInfoAll"});
			}
		},
		leave: function()
		{
			netSendDisconnect();
			network_destroy(socket);
		}
	});
	
	netState.add("Offline",{
		enter: function()
		{
			
		},
		step: function()
		{
			
		},
		leave: function()
		{
			
		}
	});
	
	#endregion
	
	#region Player States
	
	//Ground state
	snowState.add_child("Free","Ground",{
		step: function()
		{
			//Inherits free state
			snowState.inherit();
			
			if (input.general.moveDirection == 0 and stats.hVel != 0) //Decelerating
			{
				if (abs(stats.hVel) >= stats.hDecel) stats.hVel -= sign(stats.hVel) * stats.hDecel;
				else stats.hVel = 0;
			}
			else //Moving with arrow keys
			{
				// Movement acceleration, capping vel at stats.hMaxVel
				stats.hVel = clamp(stats.hVel + (input.general.moveDirection * stats.hAccel),-stats.hMaxVel,stats.hMaxVel);
				//If our velocity isn't the same as our move direction, turn instantly
				if sign(stats.hVel) != input.general.moveDirection stats.hVel = 0;
			}

			if input.general.jumpPress stats.vVel -= stats.jumpStr; //Jump
			
			//State switches
			if !onGround snowState.change("Air");
			else if input.general.downHold snowState.change("Crouch");
		},
		animation: function()
		{
			snowState.inherit();
			
			image_speed = 1;
			
			if stats.hVel == 0 sprite_index = phSpriteIdle; //Idle animation
			else
			{
				image_speed = abs(stats.hVel/stats.hMaxVel);
				sprite_index = phSpriteRun; //Run animation
				stats.xScale = sign(stats.hVel)*abs(stats.xScale);
			}
		}
	});
	//Air state
	snowState.add_child("Free","Air",{
		step: function()
		{
			//Inherits free state
			snowState.inherit();
	
			// Movement
			if (input.general.moveDirection == 0 and stats.hVel != 0)
			{
				if (abs(stats.hVel) >= stats.hAirDecel) stats.hVel -= sign(stats.hVel) * stats.hAirDecel;
				else stats.hVel = 0;
			}
			else
			{
				// Movement acceleration, capping stats.hVel at stats.hMaxVel in both directions
				stats.hVel = clamp(stats.hVel + (input.general.moveDirection * stats.hAirAccel),-stats.hMaxVel,stats.hMaxVel)
			}
			
			//stats.vVel cap
			stats.vVel = clamp(stats.vVel,-stats.vMaxVel,stats.vMaxVel)
			
			//Jump control
			if (!input.general.jumpHold and (stats.vVel < -stats.jumpControl)) stats.vVel += stats.jumpControl; //Shaves off some velocity by a set amount
			
			//State switches
			if onGround snowState.change("Ground");
			else if onWall != 0 snowState.change("Wall");
		},
		animation: function()
		{
			snowState.inherit();
			
			image_speed = abs(stats.vVel/stats.vMaxVel) + 0.5
			
			if stats.vVel < 0 
			{
				sprite_index = phSpriteJumpRise;
			}
			else
			{
				sprite_index = phSpriteJumpFall;
			}
		}
	});
	//Wall state
	snowState.add_child("Free","Wall",{
		step: function()
		{
			//Inherits free state
			snowState.inherit();
			
			//Jump
			if input.general.jumpPress
			{
				stats.vVel = -stats.wallJumpStr*0.6;
				stats.hVel = sign(stats.xScale)*stats.wallJumpStr*0.4;
			}
			
			//Slide friction
			stats.vVel = scrRoundPrecise(stats.vVel*stats.vSlideDecel,0.01) //Rounds to the hundredth (0.01)
			
			//State switches
			if onGround snowState.change("Ground")
			else if onWall = 0 snowState.change("Air")
		},
		animation: function()
		{
			snowState.inherit();
			
			image_speed = abs(stats.vVel/stats.vMaxVel) + 0.2;
			sprite_index = phSpriteWallslide;
			
			if onWall != 0 stats.xScale = -onWall*abs(stats.xScale);
		}
	});
	//Crouch state
	snowState.add_child("Free","Crouch",{
		step: function()
		{	
			//Inherits free state
			snowState.inherit();
			
			//Movement
			if stats.hVel != 0
			{
				if (abs(stats.hVel) >= stats.hSlideDecel) stats.hVel -= sign(stats.hVel) * stats.hSlideDecel;
				else stats.hVel = 0;
			}
			
			//State switches
			if !input.general.downHold snowState.change("Ground");
			else if !onGround snowState.change("Air");
		},
		animation: function()
		{
			snowState.inherit();
			
			image_speed = abs(stats.hVel/stats.hMaxVel)
			
			if stats.hVel = 0
			{
				sprite_index = phSpriteCrouch;
				if input.general.moveDirection != 0 stats.xScale = input.general.moveDirection*abs(stats.xScale);
			}
			else sprite_index = phSpriteSlide;
		}
	});
	//Attack state
	snowState.add_child("Free","Attack",{
		step: function()
		{
			//Inherits free state
			snowState.inherit();
			
			if stats.hVel != 0
			{
				if (abs(stats.hVel) >= stats.hSlideDecel) stats.hVel -= sign(stats.hVel) * stats.hSlideDecel;
				else stats.hVel = 0;
			}
			stats.xScale = sign(layer_sequence_get_xscale(entityEquip.currentSequenceElement))*stats.size;
			stats.yScale = sign(layer_sequence_get_yscale(entityEquip.currentSequenceElement))*stats.size;
			
			image_index = scrSequenceRatio(image_number,entityEquip.currentSequenceElement)
		}
	});

	#endregion

}