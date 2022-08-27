-- CreateEnum
CREATE TYPE "Role" AS ENUM ('PLAYER', 'NPC', 'ADMIN');

-- CreateEnum
CREATE TYPE "PortraitAttribute" AS ENUM ('PRIMARY', 'SECONDARY');

-- CreateTable
CREATE TABLE "Player" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL DEFAULT '',
    "showName" BOOLEAN NOT NULL DEFAULT true,
    "username" TEXT,
    "password" TEXT,
    "maxLoad" DOUBLE PRECISION NOT NULL DEFAULT 1,
    "spellSlots" DOUBLE PRECISION NOT NULL DEFAULT 1,
    "role" "Role" NOT NULL,

    CONSTRAINT "Player_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Info" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "visibleToAdmin" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Info_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Attribute" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "color" CHAR(6) NOT NULL DEFAULT '0d6efd',
    "rollable" BOOLEAN NOT NULL,
    "portrait" "PortraitAttribute",
    "visibleToAdmin" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Attribute_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AttributeStatus" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "attribute_id" INTEGER NOT NULL,

    CONSTRAINT "AttributeStatus_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Spec" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "visibleToAdmin" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Spec_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Characteristic" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "visibleToAdmin" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Characteristic_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Specialization" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "Specialization_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Skill" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "specialization_id" INTEGER,
    "startValue" INTEGER NOT NULL DEFAULT 0,
    "mandatory" BOOLEAN NOT NULL DEFAULT false,
    "visibleToAdmin" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "Skill_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Equipment" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "damage" TEXT NOT NULL,
    "range" TEXT NOT NULL,
    "attacks" TEXT NOT NULL,
    "ammo" INTEGER,
    "visible" BOOLEAN NOT NULL,

    CONSTRAINT "Equipment_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Item" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "weight" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "visible" BOOLEAN NOT NULL,

    CONSTRAINT "Item_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Currency" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "visibleToAdmin" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Currency_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ExtraInfo" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "ExtraInfo_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Spell" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "cost" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "damage" TEXT NOT NULL,
    "target" TEXT NOT NULL,
    "castingTime" TEXT NOT NULL,
    "range" TEXT NOT NULL,
    "duration" TEXT NOT NULL,
    "slots" INTEGER NOT NULL,
    "visible" BOOLEAN NOT NULL,

    CONSTRAINT "Spell_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PlayerInfo" (
    "player_id" INTEGER NOT NULL,
    "info_id" INTEGER NOT NULL,
    "value" TEXT NOT NULL,

    CONSTRAINT "PlayerInfo_pkey" PRIMARY KEY ("player_id","info_id")
);

-- CreateTable
CREATE TABLE "PlayerAttribute" (
    "player_id" INTEGER NOT NULL,
    "attribute_id" INTEGER NOT NULL,
    "value" INTEGER NOT NULL,
    "maxValue" INTEGER NOT NULL,
    "show" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "PlayerAttribute_pkey" PRIMARY KEY ("player_id","attribute_id")
);

-- CreateTable
CREATE TABLE "PlayerAttributeStatus" (
    "player_id" INTEGER NOT NULL,
    "attribute_status_id" INTEGER NOT NULL,
    "value" BOOLEAN NOT NULL,

    CONSTRAINT "PlayerAttributeStatus_pkey" PRIMARY KEY ("player_id","attribute_status_id")
);

-- CreateTable
CREATE TABLE "PlayerSpec" (
    "player_id" INTEGER NOT NULL,
    "spec_id" INTEGER NOT NULL,
    "value" TEXT NOT NULL,

    CONSTRAINT "PlayerSpec_pkey" PRIMARY KEY ("player_id","spec_id")
);

-- CreateTable
CREATE TABLE "PlayerCharacteristic" (
    "player_id" INTEGER NOT NULL,
    "characteristic_id" INTEGER NOT NULL,
    "value" INTEGER NOT NULL,
    "modifier" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "PlayerCharacteristic_pkey" PRIMARY KEY ("player_id","characteristic_id")
);

-- CreateTable
CREATE TABLE "PlayerSkill" (
    "player_id" INTEGER NOT NULL,
    "skill_id" INTEGER NOT NULL,
    "value" INTEGER NOT NULL,
    "modifier" INTEGER NOT NULL DEFAULT 0,
    "checked" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "PlayerSkill_pkey" PRIMARY KEY ("player_id","skill_id")
);

-- CreateTable
CREATE TABLE "PlayerEquipment" (
    "player_id" INTEGER NOT NULL,
    "equipment_id" INTEGER NOT NULL,
    "currentAmmo" INTEGER NOT NULL,

    CONSTRAINT "PlayerEquipment_pkey" PRIMARY KEY ("player_id","equipment_id")
);

-- CreateTable
CREATE TABLE "PlayerItem" (
    "player_id" INTEGER NOT NULL,
    "item_id" INTEGER NOT NULL,
    "currentDescription" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,

    CONSTRAINT "PlayerItem_pkey" PRIMARY KEY ("player_id","item_id")
);

-- CreateTable
CREATE TABLE "PlayerCurrency" (
    "player_id" INTEGER NOT NULL,
    "currency_id" INTEGER NOT NULL,
    "value" TEXT NOT NULL,

    CONSTRAINT "PlayerCurrency_pkey" PRIMARY KEY ("player_id","currency_id")
);

-- CreateTable
CREATE TABLE "PlayerExtraInfo" (
    "player_id" INTEGER NOT NULL,
    "extra_info_id" INTEGER NOT NULL,
    "value" TEXT NOT NULL,

    CONSTRAINT "PlayerExtraInfo_pkey" PRIMARY KEY ("player_id","extra_info_id")
);

-- CreateTable
CREATE TABLE "PlayerSpell" (
    "player_id" INTEGER NOT NULL,
    "spell_id" INTEGER NOT NULL,

    CONSTRAINT "PlayerSpell_pkey" PRIMARY KEY ("player_id","spell_id")
);

-- CreateTable
CREATE TABLE "PlayerNote" (
    "player_id" INTEGER NOT NULL,
    "value" TEXT NOT NULL,

    CONSTRAINT "PlayerNote_pkey" PRIMARY KEY ("player_id")
);

-- CreateTable
CREATE TABLE "PlayerAvatar" (
    "id" SERIAL NOT NULL,
    "player_id" INTEGER NOT NULL,
    "attribute_status_id" INTEGER,
    "link" TEXT,

    CONSTRAINT "PlayerAvatar_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Config" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "value" TEXT NOT NULL,

    CONSTRAINT "Config_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Trade" (
    "id" SERIAL NOT NULL,
    "sender_id" INTEGER NOT NULL,
    "sender_object_id" INTEGER NOT NULL,
    "receiver_id" INTEGER NOT NULL,
    "receiver_object_id" INTEGER,

    CONSTRAINT "Trade_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "PlayerAvatar_player_id_attribute_status_id_key" ON "PlayerAvatar"("player_id", "attribute_status_id");

-- CreateIndex
CREATE UNIQUE INDEX "Config_name_key" ON "Config"("name");

-- AddForeignKey
ALTER TABLE "AttributeStatus" ADD CONSTRAINT "AttributeStatus_attribute_id_fkey" FOREIGN KEY ("attribute_id") REFERENCES "Attribute"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Skill" ADD CONSTRAINT "Skill_specialization_id_fkey" FOREIGN KEY ("specialization_id") REFERENCES "Specialization"("id") ON DELETE SET NULL ON UPDATE SET NULL;

-- AddForeignKey
ALTER TABLE "PlayerInfo" ADD CONSTRAINT "PlayerInfo_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "Player"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerInfo" ADD CONSTRAINT "PlayerInfo_info_id_fkey" FOREIGN KEY ("info_id") REFERENCES "Info"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerAttribute" ADD CONSTRAINT "PlayerAttribute_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "Player"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerAttribute" ADD CONSTRAINT "PlayerAttribute_attribute_id_fkey" FOREIGN KEY ("attribute_id") REFERENCES "Attribute"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerAttributeStatus" ADD CONSTRAINT "PlayerAttributeStatus_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "Player"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerAttributeStatus" ADD CONSTRAINT "PlayerAttributeStatus_attribute_status_id_fkey" FOREIGN KEY ("attribute_status_id") REFERENCES "AttributeStatus"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerSpec" ADD CONSTRAINT "PlayerSpec_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "Player"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerSpec" ADD CONSTRAINT "PlayerSpec_spec_id_fkey" FOREIGN KEY ("spec_id") REFERENCES "Spec"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerCharacteristic" ADD CONSTRAINT "PlayerCharacteristic_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "Player"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerCharacteristic" ADD CONSTRAINT "PlayerCharacteristic_characteristic_id_fkey" FOREIGN KEY ("characteristic_id") REFERENCES "Characteristic"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerSkill" ADD CONSTRAINT "PlayerSkill_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "Player"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerSkill" ADD CONSTRAINT "PlayerSkill_skill_id_fkey" FOREIGN KEY ("skill_id") REFERENCES "Skill"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerEquipment" ADD CONSTRAINT "PlayerEquipment_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "Player"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerEquipment" ADD CONSTRAINT "PlayerEquipment_equipment_id_fkey" FOREIGN KEY ("equipment_id") REFERENCES "Equipment"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerItem" ADD CONSTRAINT "PlayerItem_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "Player"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerItem" ADD CONSTRAINT "PlayerItem_item_id_fkey" FOREIGN KEY ("item_id") REFERENCES "Item"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerCurrency" ADD CONSTRAINT "PlayerCurrency_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "Player"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerCurrency" ADD CONSTRAINT "PlayerCurrency_currency_id_fkey" FOREIGN KEY ("currency_id") REFERENCES "Currency"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerExtraInfo" ADD CONSTRAINT "PlayerExtraInfo_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "Player"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerExtraInfo" ADD CONSTRAINT "PlayerExtraInfo_extra_info_id_fkey" FOREIGN KEY ("extra_info_id") REFERENCES "ExtraInfo"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerSpell" ADD CONSTRAINT "PlayerSpell_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "Player"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerSpell" ADD CONSTRAINT "PlayerSpell_spell_id_fkey" FOREIGN KEY ("spell_id") REFERENCES "Spell"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerNote" ADD CONSTRAINT "PlayerNote_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "Player"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerAvatar" ADD CONSTRAINT "PlayerAvatar_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "Player"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PlayerAvatar" ADD CONSTRAINT "PlayerAvatar_attribute_status_id_fkey" FOREIGN KEY ("attribute_status_id") REFERENCES "AttributeStatus"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Trade" ADD CONSTRAINT "Trade_sender_id_fkey" FOREIGN KEY ("sender_id") REFERENCES "Player"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Trade" ADD CONSTRAINT "Trade_receiver_id_fkey" FOREIGN KEY ("receiver_id") REFERENCES "Player"("id") ON DELETE CASCADE ON UPDATE CASCADE;
