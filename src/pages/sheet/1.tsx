import { GetServerSidePropsContext } from 'next';
import Router from 'next/router';
import React, { useEffect, useRef, useState } from 'react';
import Col from 'react-bootstrap/Col';
import Container from 'react-bootstrap/Container';
import Row from 'react-bootstrap/Row';
import ApplicationHead from '../../components/ApplicationHead';
import DataContainer from '../../components/DataContainer';
import ErrorToastContainer from '../../components/ErrorToastContainer';
import DiceRollResultModal from '../../components/Modals/DiceRollResultModal';
import PlayerAttributeContainer from '../../components/Player/PlayerAttributeContainer';
import PlayerEquipmentContainer from '../../components/Player/PlayerEquipmentContainer';
import PlayerItemContainer from '../../components/Player/PlayerItemContainer';
import PlayerCharacteristicField from '../../components/Player/PlayerCharacteristicField';
import PlayerInfoField from '../../components/Player/PlayerInfoField';
import PlayerSpecField from '../../components/Player/PlayerSpecField';
import PlayerSkillContainer from '../../components/Player/PlayerSkillContainer';
import PlayerSpellContainer from '../../components/Player/PlayerSpellContainer';
import SheetNavbar from '../../components/SheetNavbar';
import { ErrorLogger, ShowDiceResult, Socket } from '../../contexts';
import useSocket, { SocketIO } from '../../hooks/useSocket';
import useToast from '../../hooks/useToast';
import { DiceResult, ResolvedDice } from '../../utils/dice';
import api from '../../utils/api';
import { ContainerConfig, DiceConfig } from '../../utils/config';
import prisma from '../../utils/database';
import { sessionSSR } from '../../utils/session';
import { InferSSRProps } from '../../utils';

const BONUS_DAMAGE_NAME = 'Dano Bônus';

export default function Sheet1(props: InferSSRProps<typeof getSSP>) {

	const [toasts, addToast] = useToast();

	const [socket, setSocket] = useState<SocketIO | null>(null);

	//TODO: Find a way to bring this diceRoll state down in the hierarchy. diceRoll state is
	//only needed for PlayerAttributeContainer, PlayerCharacteristicField,
	//PlayerEquipmentContainer and PlayerSkillContainer.
	const [diceRoll, setDiceRoll] = useState<{
		dices: ResolvedDice[];
		resolverKey?: string;
		onResult?: (result: DiceResult[]) => void;
	}>({ dices: [] });

	const bonusDamage = useRef(
		props.player.PlayerSpec.find((spec) => spec.Spec.name === BONUS_DAMAGE_NAME)?.value
	);
	const lastRoll = useRef<{
		dices: ResolvedDice[];
		resolverKey?: string;
		onResult?: (result: DiceResult[]) => void;
	}>({ dices: [] });

	function onSpecChanged(name: string, value: string) {
		if (name !== BONUS_DAMAGE_NAME) return;
		bonusDamage.current = value;
	}

	useSocket((socket) => {
		socket.emit('roomJoin', `player${props.player.id}`);
		setSocket(socket);
	});

	useEffect(() => {
		if (!socket) return;
		socket.on('playerDelete', () =>
			api.delete('/player').then(() => Router.replace('/'))
		);
		return () => {
			socket.off('playerDelete');
		};
		// eslint-disable-next-line react-hooks/exhaustive-deps
	}, [socket]);

	function onDiceRoll(
		dices: ResolvedDice[],
		resolverKey?: string,
		onResult?: (result: DiceResult[]) => void
	) {
		const roll = { dices, resolverKey, onResult };
		lastRoll.current = roll;
		setDiceRoll(roll);
	}

	if (!socket)
		return (
			<Row className='text-center align-items-center w-100' style={{ height: '100vh' }}>
				<Col>
					<h1>Carregando Ficha...</h1>
				</Col>
			</Row>
		);

	return (
		<>
			<ApplicationHead title='Ficha do Personagem' />
			<SheetNavbar />
			<ErrorLogger.Provider value={addToast}>
				<Socket.Provider value={socket}>
					<Container>
						<Row className='display-5 text-center'>
							<Col>Ficha do Personagem</Col>
						</Row>
						<ShowDiceResult.Provider value={onDiceRoll}>
							<Row className='mb-3'>
								<DataContainer
									outline
									title={
										props.containerConfig.find(
											(c) => c.originalName === 'Detalhes Pessoais'
										)?.name || 'Detalhes Pessoais'
									}>
									<>
										{props.player.PlayerInfo.map((info) => (
											<Row className='mb-4' key={info.Info.id}>
												<Col className='mx-2'>
													<Row>
														<label className='h5' htmlFor={`info${info.Info.id}`}>
															{info.Info.name}
														</label>
														<PlayerInfoField infoId={info.Info.id} value={info.value} />
													</Row>
												</Col>
											</Row>
										))}
										<hr />
										<Row className='justify-content-center'>
											{props.player.PlayerSpec.map((spec) => (
												<Col
													key={spec.Spec.id}
													xs={12}
													sm={6}
													lg={4}
													className='text-center mb-2'>
													<PlayerSpecField
														value={spec.value}
														specId={spec.Spec.id}
														name={spec.Spec.name}
														onSpecChanged={onSpecChanged}
													/>
													<label htmlFor={`spec${spec.Spec.id}`}>{spec.Spec.name}</label>
												</Col>
											))}
										</Row>
									</>
								</DataContainer>
								<Col>
									<PlayerAttributeContainer
										playerAttributes={props.player.PlayerAttributes}
										attributeDiceConfig={props.diceConfig.attribute}
										playerAttributeStatus={props.player.PlayerAttributeStatus}
										playerAvatars={props.player.PlayerAvatar}
									/>
								</Col>
							</Row>
							<Row>
								<DataContainer
									outline
									title={
										props.containerConfig.find(
											(c) => c.originalName === 'Características'
										)?.name || 'Características'
									}>
									<Row className='mb-3 text-center align-items-end justify-content-center'>
										{props.player.PlayerCharacteristic.map((char) => (
											<PlayerCharacteristicField
												key={char.Characteristic.id}
												modifier={char.modifier}
												characteristic={char.Characteristic}
												value={char.value}
												characteristicDiceConfig={
													props.diceConfig.characteristic || props.diceConfig.base
												}
											/>
										))}
									</Row>
								</DataContainer>
							</Row>
							<Row>
								<PlayerEquipmentContainer
									availableEquipments={props.availableEquipments}
									playerEquipments={props.player.PlayerEquipment}
									title={
										props.containerConfig.find((c) => c.originalName === 'Combate')
											?.name || 'Combate'
									}
									bonusDamage={bonusDamage}
								/>
							</Row>
							<Row>
								<PlayerSkillContainer
									playerSkills={props.player.PlayerSkill}
									availableSkills={props.availableSkills}
									skillDiceConfig={props.diceConfig.skill || props.diceConfig.base}
									title={
										props.containerConfig.find((c) => c.originalName === 'Perícias')
											?.name || 'Perícias'
									}
									automaticMarking={props.automaticMarking}
								/>
							</Row>
						</ShowDiceResult.Provider>
						<Row>
							<PlayerItemContainer
								playerItems={props.player.PlayerItem}
								availableItems={props.availableItems}
								playerMaxLoad={props.player.maxLoad}
								playerCurrency={props.player.PlayerCurrency}
								title={
									props.containerConfig.find((c) => c.originalName === 'Itens')?.name ||
									'Itens'
								}
							/>
						</Row>
						<Row>
							<PlayerSpellContainer
								playerSpells={props.player.PlayerSpell.map((sp) => sp.Spell)}
								availableSpells={props.availableSpells}
								playerMaxSlots={props.player.spellSlots}
								title={
									props.containerConfig.find((c) => c.originalName === 'Magias')?.name ||
									'Magias'
								}
							/>
						</Row>
					</Container>
				</Socket.Provider>
				<DiceRollResultModal
					dices={diceRoll.dices}
					resolverKey={diceRoll.resolverKey}
					onDiceResult={diceRoll.onResult}
					onHide={() => setDiceRoll({ dices: [], resolverKey: undefined })}
					onRollAgain={() => setDiceRoll(lastRoll.current)}
				/>
			</ErrorLogger.Provider>
			<ErrorToastContainer toasts={toasts} />
		</>
	);
}

async function getSSP(ctx: GetServerSidePropsContext) {
	const player = ctx.req.session.player;

	if (!player) {
		return {
			redirect: {
				destination: '/',
				permanent: false,
			},
		};
	}

	const results = await prisma.$transaction([
		prisma.player.findUnique({
			where: { id: player.id },
			select: {
				id: true,
				maxLoad: true,
				spellSlots: true,
				PlayerInfo: { select: { Info: true, value: true } },
				PlayerAvatar: { select: { AttributeStatus: true, link: true } },
				PlayerAttributes: { select: { Attribute: true, value: true, maxValue: true } },
				PlayerAttributeStatus: { select: { AttributeStatus: true, value: true } },
				PlayerSpec: { select: { Spec: true, value: true } },
				PlayerCharacteristic: {
					select: { Characteristic: true, value: true, modifier: true },
				},
				PlayerEquipment: { select: { Equipment: true, currentAmmo: true } },
				PlayerSkill: {
					select: {
						Skill: {
							select: {
								id: true,
								name: true,
								Specialization: { select: { name: true } },
							},
						},
						value: true,
						checked: true,
					},
				},
				PlayerCurrency: { select: { value: true, Currency: true } },
				PlayerItem: { select: { Item: true, currentDescription: true, quantity: true } },
				PlayerSpell: { select: { Spell: true } },
			},
		}),
		prisma.equipment.findMany({
			where: { visible: true, PlayerEquipment: { none: { player_id: player.id } } },
		}),
		prisma.skill.findMany({
			where: { PlayerSkill: { none: { player_id: player.id } } },
		}),
		prisma.item.findMany({
			where: { visible: true, PlayerItem: { none: { player_id: player.id } } },
		}),
		prisma.spell.findMany({
			where: { visible: true, PlayerSpell: { none: { player_id: player.id } } },
		}),
		prisma.config.findUnique({ where: { name: 'dice' } }),
		prisma.config.findUnique({ where: { name: 'container' } }),
		prisma.config.findUnique({ where: { name: 'enable_automatic_markers' } }),
	]);

	if (!results[0]) {
		ctx.req.session.destroy();
		return {
			redirect: {
				destination: '/',
				permanent: false,
			},
		};
	}

	return {
		props: {
			player: results[0],
			availableEquipments: results[1],
			availableSkills: results[2],
			availableItems: results[3],
			availableSpells: results[4],
			diceConfig: JSON.parse(results[5]?.value || 'null') as DiceConfig,
			containerConfig: JSON.parse(results[6]?.value || '[]') as ContainerConfig,
			automaticMarking: results[7]?.value === 'true' ? true : false,
		},
	};
}
export const getServerSideProps = sessionSSR(getSSP);
