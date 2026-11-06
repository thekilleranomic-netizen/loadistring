--[[
    KRYPTON LAUNCHER - Loader UI (LocalScript unique)  |  v1.8.8
    v1.8.8 : icônes de l'onglet Profils 100% vectorielles (Frames) -> identiques sur tous les appareils
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")

-- Correction spécifique pour Delta et les autres executors mobiles
local globalRequest = (syn and syn.request) or (http and http.request) or http_request or request or (fluxus and fluxus.request) or (Krnl and Krnl.request)

---------------------------------------------------------------------
-- CONFIG
---------------------------------------------------------------------
local Config = {
	Name = "Krypton",
	Subtitle = "LAUNCHER",
	DefaultLanguage = "FR",
	DiscordLink = "https://discord.gg/QrwXuueSA5",
	DiscordCode = "QrwXuueSA5",
	LogoFile = "",
	LogoImage = "rbxassetid://0",
	DiscordFile = "",
	DiscordImage = "rbxassetid://0",
	ApiBaseUrl = "https://krypton-dm2t.onrender.com",
	LoginPath = "/api/login",
	RegisterPath = "/api/register",
	KeyFile = "krypton_license.json",
	LangFile = "krypton_lang.txt",
	ProfilesFile = "krypton_profiles.json",
	CheckUsername = false,
	SupportedGames = { "urban reload", "one state" },
	SupportedPlaceIds = {},
}

local Lang = {
	EN = {
		welcome = "Welcome back", sub = "Enter your details to continue.",
		subSignup = "Create your account.",
		userPh = "Username", passPh = "Password",
		remember = "Remember me",
		signin = "Sign in", signup = "Sign up", verifying = "Verifying...", granted = "Access granted",
		emptyUser = "Please enter your username.", emptyPass = "Please enter your password.",
		shortPass = "Password must be at least 4 characters.",
		badCreds = "Invalid username or password.", userTaken = "This username is already taken.",
		noAccount = "No account found with this username.",
		expired = "Account expired.",
		hwid = "This account is linked to another device.",
		device_limit = "An account already exists on this device or network.",
		no_hwid = "Device ID not detected.",
		rate = "Too many requests. Please slow down.",
		copied = "Link copied to clipboard.",
		dashLoading = "Loading...", dashReady = "Ready",
		gameSupported = "Game supported", gameUnsupported = "Game not supported",
		license = "STATUS", expires = "EXPIRES", lifetime = "Lifetime", days = " days",
		expiresAt = "Expires at: ", expiresOn = "Expires on: ", comingSoon = "Coming soon",
		language = "Language", chooseLang = "Choose the menu language",
		stepLicense = "Checking account", stepGame = "Loading game", stepMenu = "Preparing menu",
		previewTitle = "ESP Preview", playersLbl = "Players",
		lblUser = "USER", lblKey = "KEY", lblDEVICE = "DEVICE",
		optDistance = "Draw Distance", snapTop = "Top", snapBottom = "Bottom",
		resetHwid = "Reset HWID", resetDesc = "Unlink this account from your current device.",
		resetBtn = "Reset", resetConfirm = "Confirm?", resetting = "Resetting...", resetOk = "Done ✓", resetFail = "Failed",
		optEnable = "Enable ESP", optBoxes = "Draw Boxes", optSnaplines = "Draw Snaplines",
		optSkeleton = "Draw Skeleton", optNames = "Draw Names", optHealth = "Draw Health",
		optArmor = "Draw Armor", optWeapon = "Draw Enemy Weapon", optCount = "Show Player Count",
		comingSoonTitle = "Coming soon",
		adminAlertTitle = "Enable Admin Alert",
		adminAlertDesc = "Alerts you when an administrator joins or is present.",
		catVisuals = "Visuals", catAssist = "Assistance", catPlayer = "Player", catFarm = "Farm", catMisc = "Misc", catCustom = "Customize",
		subGeneral = "General", subAdvanced = "Advanced",
		subSettings = "Settings", subProfils = "Profiles", subTranslation = "Translation",
		settingsTitle = "Settings",
		profilesCount = "Saved Profiles (%d/10)",
		newProfileName = "New Profile",
		toastCreated = "CREATED", toastSaved = "SAVED", toastLoaded = "LOADED", toastRenamed = "RENAMED", toastDeleted = "DELETED", toastReset = "RESET",
		noRequest = "Executor HTTP request not supported.",
		errServer = "Server communication error.",
		getKeyBtn = "Join the Discord",
	},
	FR = {
		welcome = "Bon retour", sub = "Entre tes informations pour continuer.",
		subSignup = "Crée ton compte.",
		userPh = "Nom d'utilisateur", passPh = "Mot de passe",
		remember = "Se souvenir de moi",
		signin = "Connexion", signup = "Inscription", verifying = "Vérification...", granted = "Accès autorisé",
		emptyUser = "Entre ton nom d'utilisateur.", emptyPass = "Entre ton mot de passe.",
		shortPass = "Le mot de passe doit faire au moins 4 caractères.",
		badCreds = "Nom d'utilisateur ou mot de passe incorrect.", userTaken = "Ce nom d'utilisateur est déjà pris.",
		noAccount = "Aucun compte avec ce nom d'utilisateur.",
		expired = "Compte expiré.",
		hwid = "Ce compte est lié à un autre appareil.",
		device_limit = "Un compte existe déjà sur cet appareil ou ce réseau.",
		no_hwid = "Identifiant d'appareil non détecté.",
		rate = "Trop de requêtes. Veuillez patienter.",
		copied = "Lien copié dans le presse-papiers.",
		dashLoading = "Chargement...", dashReady = "Prêt",
		gameSupported = "Jeu supporté", gameUnsupported = "Jeu non supporté",
		license = "STATUT", expires = "EXPIRE", lifetime = "Lifetime", days = " j",
		expiresAt = "Expire dans : ", expiresOn = "Expire le : ", comingSoon = "Bientôt disponible",
		language = "Langue", chooseLang = "Choisis la langue du menu",
		stepLicense = "Vérification du compte", stepGame = "Chargement du jeu", stepMenu = "Préparation du menu",
		previewTitle = "Aperçu ESP", playersLbl = "Joueurs",
		lblUser = "UTILISATEUR", lblKey = "CLÉ", lblDEVICE = "APPAREIL",
		optDistance = "Afficher la distance", snapTop = "Haut", snapBottom = "Bas",
		resetHwid = "Réinitialiser le HWID", resetDesc = "Délie ce compte de ton appareil actuel.",
		resetBtn = "Réinitialiser", resetConfirm = "Confirmer ?", resetting = "En cours...", resetOk = "Fait ✓", resetFail = "Échec",
		optEnable = "Activer l'ESP", optBoxes = "Afficher les boîtes", optSnaplines = "Afficher les lignes",
		optSkeleton = "Afficher le squelette", optNames = "Afficher les noms", optHealth = "Afficher la vie",
		optArmor = "Afficher l'armure", optWeapon = "Afficher l'arme ennemie", optCount = "Afficher le nombre de joueurs",
		comingSoonTitle = "Bientôt disponible",
		adminAlertTitle = "Activer l'alerte admin",
		adminAlertDesc = "Vous avertit lorsqu'un administrateur rejoint ou est présent.",
		catVisuals = "Visuels", catAssist = "Assistance", catPlayer = "Joueur", catFarm = "Farm", catMisc = "Misc", catCustom = "Personnaliser",
		subGeneral = "Général", subAdvanced = "Avancé",
		subSettings = "Paramètres", subProfils = "Profils", subTranslation = "Traduction",
		settingsTitle = "Paramètres",
		profilesCount = "Profils sauvegardés (%d/10)",
		newProfileName = "Nouveau Profil",
		toastCreated = "CRÉÉ", toastSaved = "SAUVEGARDÉ", toastLoaded = "CHARGÉ", toastRenamed = "RENOMMÉ", toastDeleted = "SUPPRIMÉ", toastReset = "RÉINITIALISÉ",
		noRequest = "Requête HTTP non supportée par l'executor.",
		errServer = "Erreur de communication avec le serveur.",
		getKeyBtn = "Rejoindre le Discord",
	},
}

local currentLang = Config.DefaultLanguage

local function alive(o)
	return o ~= nil and o.Parent ~= nil and o:IsDescendantOf(game)
end

local function saveLang()
	if writefile then pcall(writefile, Config.LangFile, currentLang) end
end
do
	local ok, v = pcall(function()
		if isfile and isfile(Config.LangFile) and readfile then return readfile(Config.LangFile) end
	end)
	if ok and (v == "FR" or v == "EN") then currentLang = v end
end

local function S(key) return Lang[currentLang][key] or Lang.EN[key] or key end

local Settings = {
	Visuals = {
		enable = false, boxes = false, snaplines = false, skeleton = false,
		names = false, distance = false, health = false, armor = false, weapon = false, count = false,
		snapPos = "Bottom",
		adminAlert = false,
	},
}
pcall(function() if getgenv then getgenv().KryptonSettings = Settings end end)

local Authed = false
local Session = { password = "" }

---------------------------------------------------------------------
-- THEME
---------------------------------------------------------------------
local C = {
	bg = Color3.fromRGB(10, 10, 11),
	panel = Color3.fromRGB(17, 17, 19),
	field = Color3.fromRGB(19, 19, 21),
	stroke = Color3.fromRGB(38, 38, 43),
	tabBg = Color3.fromRGB(14, 14, 16),
	tabSel = Color3.fromRGB(28, 28, 32),
	text = Color3.fromRGB(255, 255, 255),
	muted = Color3.fromRGB(120, 120, 128),
	err = Color3.fromRGB(255, 99, 99),
	good = Color3.fromRGB(110, 231, 140),
	discord = Color3.fromRGB(88, 101, 242),
}

---------------------------------------------------------------------
-- DÉCODEUR BASE64 & CHARGEMENT DES ASSETS
---------------------------------------------------------------------
local function b64decode(data)
	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	local lookup = {}
	for i = 1, #chars do lookup[string.byte(chars, i)] = i - 1 end
	local out, n, buf, bits = {}, 0, 0, 0
	for i = 1, #data do
		local v = lookup[string.byte(data, i)]
		if v then
			buf = buf * 64 + v
			bits += 6
			if bits >= 8 then
				bits -= 8
				local p = 2 ^ bits
				local byte = math.floor(buf / p)
				buf = buf % p
				n += 1
				out[n] = string.char(byte)
			end
		end
	end
	return table.concat(out)
end

-- Les icônes de l'onglet Profils sont désormais dessinées en vectoriel (voir plus bas),
-- seule l'icône "k" (bouton flottant) reste en image avec fallback texte.
local EMBED_ICONS = {
	k = "iVBORw0KGgoAAAANSUhEUgAAAKAAAACgCAYAAACLz2ctAABGJUlEQVR42u29eZwV5Zkv/jzvW1VnX3oDGpAdgcYFUGYFG+OCCuzoysZkZYzITJzHrLPd3M/PJLNf25M5kbu6dGDcmyczExGQ0uEddl0RAtUGNzJSgqKoaJioqiKCqqA4qCICqqI2aWjTMRJ7NlJgZ3vOuekS132zGZzWb23n3vT1fn25v61Tvv3Hvv+x9M5+cFAwAYBwA=",
}

local customAsset = getcustomasset or getsynasset
local function resolveImage(file, id, embedded, embeddedName)
	if file and file ~= "" and customAsset and isfile then
		local ok, res = pcall(function()
			if isfile(file) then return customAsset(file) end
		end)
		if ok and res then return res end
	end
	if id and id ~= "" and id ~= "rbxassetid://0" then return id end
	if customAsset and isfile then
		local ok, res = pcall(function()
			if isfile(embeddedName) then return customAsset(embeddedName) end
		end)
		if ok and res then return res end
	end
	if embedded and embedded ~= "" and writefile and customAsset then
		local ok, res = pcall(function()
			writefile(embeddedName, b64decode(embedded))
			return customAsset(embeddedName)
		end)
		if ok and res then return res end
	end
	return nil
end

local LogoAsset = resolveImage(Config.LogoFile, Config.LogoImage, "", "krypton_logo_v18.png")
local DiscordAsset = resolveImage(Config.DiscordFile, Config.DiscordImage, "", "krypton_discord.jpg")

local IconAssets = {}
for _, name in ipairs({ "eye", "aim", "user", "farm", "gear", "palette" }) do
	IconAssets[name] = resolveImage("", "", "", "krypton_ico_" .. name .. "_v3.png")
end
IconAssets.k = resolveImage("", "", EMBED_ICONS.k, "krypton_ico_k_v3.png")

---------------------------------------------------------------------
-- HELPERS DE CONSTRUCTION & SÉCURITÉ AUTOLOCALIZE
---------------------------------------------------------------------
local function applyAutoLocalize(o)
	pcall(function()
		if o:IsA("GuiObject") or o:IsA("LayerCollector") or o:IsA("CoreGui") then
			o.AutoLocalize = false
		end
	end)
end

local function new(class, props, parent)
	local o = Instance.new(class)
	applyAutoLocalize(o)
	for k, v in pairs(props) do o[k] = v end
	if parent then o.Parent = parent end
	return o
end

local function setupGuiProtection(guiInst)
	applyAutoLocalize(guiInst)
	for _, d in ipairs(guiInst:GetDescendants()) do applyAutoLocalize(d) end
	guiInst.DescendantAdded:Connect(applyAutoLocalize)
end

local function corner(o, r) return new("UICorner", { CornerRadius = UDim.new(0, r) }, o) end
local function cornerS(o, s) return new("UICorner", { CornerRadius = UDim.new(s, 0) }, o) end
local function stroke(o, col, th, tr)
	return new("UIStroke", { Color = col, Thickness = th or 1, Transparency = tr or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, o)
end
local function tween(o, t, p, style, dir)
	TweenService:Create(o, TweenInfo.new(t, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), p):Play()
end
local function label(parent, text, size, pos, sz, color, font, alignX)
	return new("TextLabel", {
		BackgroundTransparency = 1, Text = text, TextSize = size,
		Position = pos, Size = sz, TextColor3 = color or C.text,
		Font = font or Enum.Font.GothamMedium, TextXAlignment = alignX or Enum.TextXAlignment.Left,
	}, parent)
end
local function holder(parent, x, y, w, h, clip)
	return new("Frame", {
		Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(w, h),
		BackgroundTransparency = 1, ClipsDescendants = clip or false,
	}, parent)
end
local function ring(parent, x, y, w, h, r, color, th)
	local f = new("Frame", {
		Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(w, h), BackgroundTransparency = 1,
	}, parent)
	corner(f, r)
	stroke(f, color, th or 1.5)
	return f
end

local function typeText(lbl, text)
	local id = (lbl:GetAttribute("tid") or 0) + 1
	lbl:SetAttribute("tid", id)
	task.spawn(function()
		local n = utf8.len(text) or #text
		for i = 1, n do
			if lbl:GetAttribute("tid") ~= id then return end
			local e = (utf8.offset(text, i + 1) or (#text + 1)) - 1
			lbl.Text = string.sub(text, 1, e)
			task.wait(0.022)
		end
		if lbl:GetAttribute("tid") == id then lbl.Text = text end
	end)
end

local function makeParticles(parent, w, h, count)
	local ps = {}
	for i = 1, count do
		local s = math.random(2, 4)
		local f = new("Frame", {
			Size = UDim2.fromOffset(s, s), BackgroundColor3 = Color3.fromRGB(200, 200, 210),
			BorderSizePixel = 0, BackgroundTransparency = 1,
		}, parent)
		corner(f, 2)
		ps[i] = { f = f, x = math.random(0, w), y = math.random(0, h), v = math.random(10, 32), sw = math.random() * 6, a = math.random(4, 12), max = math.random(55, 85) / 100 }
	end
	local t = 0
	local conn
	conn = RunService.RenderStepped:Connect(function(dt)
		if not alive(parent) then conn:Disconnect() return end
		t += dt
		for _, p in ipairs(ps) do
			p.y -= p.v * dt
			if p.y < -6 then p.y = h + 6; p.x = math.random(0, w) end
			p.f.Position = UDim2.fromOffset(p.x + math.sin(t + p.sw) * p.a, p.y)
			local edge = math.min(p.y / h, (h - p.y) / h) * 4
			p.f.BackgroundTransparency = 1 - math.clamp(edge, 0, 1) * (1 - p.max)
		end
	end)
end

local function makeDraggable(target, handle)
	local dragging, startPos, startMouse
	handle.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging, startMouse, startPos = true, i.Position, target.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - startMouse
			target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

---------------------------------------------------------------------
-- SQUELETTE PARTAGÉ (ESP & Aperçu)
---------------------------------------------------------------------
local SKELETON_BONES = {
	{ "Head", "Neck" },
	{ "Neck", "Chest" },
	{ "Chest", "Pelvis" },
	{ "Neck", "L_Shoulder" },
	{ "Neck", "R_Shoulder" },
	{ "L_Shoulder", "L_Elbow" },
	{ "L_Elbow", "L_Hand" },
	{ "L_Hand", "L_Tip" },
	{ "R_Shoulder", "R_Elbow" },
	{ "R_Elbow", "R_Hand" },
	{ "R_Hand", "R_Tip" },
	{ "Pelvis", "L_Hip" },
	{ "L_Hip", "L_Knee" },
	{ "L_Knee", "L_Foot" },
	{ "Pelvis", "R_Hip" },
	{ "R_Hip", "R_Knee" },
	{ "R_Knee", "R_Foot" },
}

local JOINT_NAMES = { "Head", "Neck", "Chest", "Pelvis", "L_Shoulder", "R_Shoulder", "L_Elbow", "R_Elbow", "L_Hand", "R_Hand", "L_Tip", "R_Tip", "L_Hip", "R_Hip", "L_Knee", "R_Knee", "L_Foot", "R_Foot" }

local function mkBone(parent, col)
	local shadow = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.45, BorderSizePixel = 0, Visible = false, ZIndex = 1 }, parent)
	cornerS(shadow, 0.5)
	local f = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = col, BorderSizePixel = 0, Visible = false, ZIndex = 2 }, parent)
	cornerS(f, 0.5)
	return f, shadow
end

local function mkJoint(parent, col, size)
	local f = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(size, size), BackgroundColor3 = col, BorderSizePixel = 0, Visible = false, ZIndex = 3 }, parent)
	cornerS(f, 0.5)
	return f
end

local function setBoneLine(f, shadow, x1, y1, x2, y2, th)
	local dx, dy = x2 - x1, y2 - y1
	local len = math.sqrt(dx * dx + dy * dy)
	local pos = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2)
	local rot = math.deg(math.atan2(dy, dx))
	f.Position = pos
	f.Size = UDim2.fromOffset(len, th)
	f.Rotation = rot
	f.Visible = true
	if shadow then
		shadow.Position = pos
		shadow.Size = UDim2.fromOffset(len, th + 2)
		shadow.Rotation = rot
		shadow.Visible = true
	end
end

local function motorPos(modelOrChar, motorName)
	local m = modelOrChar:FindFirstChild(motorName, true)
	if m and m:IsA("Motor6D") and m.Part0 and m.Part1 then
		return (m.Part0.CFrame * m.C0).Position
	end
	return nil
end

local function getSkeletonPoints(modelOrChar)
	local points = {}
	local head = modelOrChar:FindFirstChild("Head")
	if head then points["Head"] = head.Position end

	local upperTorso = modelOrChar:FindFirstChild("UpperTorso")
	local lowerTorso = modelOrChar:FindFirstChild("LowerTorso")
	local torso = modelOrChar:FindFirstChild("Torso")

	if upperTorso then
		points["Chest"] = upperTorso.Position
		points["Pelvis"] = lowerTorso and lowerTorso.Position or upperTorso.Position - Vector3.new(0, 1, 0)
		points["Neck"] = motorPos(modelOrChar, "Neck") or (upperTorso.Position + Vector3.new(0, upperTorso.Size.Y / 2, 0))

		points["L_Shoulder"] = motorPos(modelOrChar, "LeftShoulder")
		points["R_Shoulder"] = motorPos(modelOrChar, "RightShoulder")
		points["L_Elbow"] = motorPos(modelOrChar, "LeftElbow")
		points["R_Elbow"] = motorPos(modelOrChar, "RightElbow")

		local lHandPart = modelOrChar:FindFirstChild("LeftHand") or modelOrChar:FindFirstChild("LeftLowerArm")
		local rHandPart = modelOrChar:FindFirstChild("RightHand") or modelOrChar:FindFirstChild("RightLowerArm")
		local lw = motorPos(modelOrChar, "LeftWrist") or (lHandPart and lHandPart.Position)
		local rw = motorPos(modelOrChar, "RightWrist") or (rHandPart and rHandPart.Position)
		points["L_Hand"] = lw
		points["R_Hand"] = rw
		if lHandPart then points["L_Tip"] = lHandPart.CFrame * Vector3.new(0, -lHandPart.Size.Y / 2, 0) else points["L_Tip"] = lw end
		if rHandPart then points["R_Tip"] = rHandPart.CFrame * Vector3.new(0, -rHandPart.Size.Y / 2, 0) else points["R_Tip"] = rw end

		points["L_Hip"] = motorPos(modelOrChar, "LeftHip")
		points["R_Hip"] = motorPos(modelOrChar, "RightHip")
		points["L_Knee"] = motorPos(modelOrChar, "LeftKnee")
		points["R_Knee"] = motorPos(modelOrChar, "RightKnee")

		local lFootPart = modelOrChar:FindFirstChild("LeftFoot") or modelOrChar:FindFirstChild("LeftAnkle")
		local rFootPart = modelOrChar:FindFirstChild("RightFoot") or modelOrChar:FindFirstChild("RightAnkle")
		points["L_Foot"] = motorPos(modelOrChar, "LeftAnkle") or (lFootPart and lFootPart.Position)
		points["R_Foot"] = motorPos(modelOrChar, "RightAnkle") or (rFootPart and rFootPart.Position)

		-- Fallbacks pour R15 si Motor6D manquants
		for _, name in ipairs(JOINT_NAMES) do
			if not points[name] then
				local pPart = modelOrChar:FindFirstChild(name == "L_Hand" and "LeftHand" or name == "R_Hand" and "RightHand" or name)
				if pPart then points[name] = pPart.Position end
			end
		end
	elseif torso then
		local tcf, tsz = torso.CFrame, torso.Size
		points["Neck"] = tcf * Vector3.new(0, tsz.Y / 2, 0)
		points["Chest"] = tcf.Position
		points["Pelvis"] = tcf * Vector3.new(0, -tsz.Y / 2, 0)
		points["L_Shoulder"] = tcf * Vector3.new(-tsz.X / 2, tsz.Y / 2 - 0.5, 0)
		points["R_Shoulder"] = tcf * Vector3.new(tsz.X / 2, tsz.Y / 2 - 0.5, 0)
		points["L_Hip"] = tcf * Vector3.new(-tsz.X / 4, -tsz.Y / 2, 0)
		points["R_Hip"] = tcf * Vector3.new(tsz.X / 4, -tsz.Y / 2, 0)

		for _, side in ipairs({ {"Left", "L"}, {"Right", "R"} }) do
			local arm = modelOrChar:FindFirstChild(side[1] .. " Arm")
			local leg = modelOrChar:FindFirstChild(side[1] .. " Leg")
			if arm then
				local acf, asz = arm.CFrame, arm.Size
				local hand = acf * Vector3.new(0, -asz.Y / 2, 0)
				points[side[2] .. "_Hand"] = hand
				points[side[2] .. "_Tip"] = hand - Vector3.new(0, 0.5, 0)
				points[side[2] .. "_Elbow"] = (points[side[2] .. "_Shoulder"] + hand) / 2
			end
			if leg then
				local lcf, lsz = leg.CFrame, leg.Size
				local foot = lcf * Vector3.new(0, -lsz.Y / 2, 0)
				points[side[2] .. "_Foot"] = foot
				points[side[2] .. "_Knee"] = (points[side[2] .. "_Hip"] + foot) / 2
			end
		end
	end
	return points
end

---------------------------------------------------------------------
-- ICONES & PICTOGRAMMES
---------------------------------------------------------------------
local Icons = {}

function Icons.lock(parent, x, y, color)
	local h = holder(parent, x, y, 18, 18)
	ring(h, 4.5, 0.5, 9, 10, 4.5, color, 1.6)
	cornerS(new("Frame", { Position = UDim2.fromOffset(2, 8), Size = UDim2.fromOffset(14, 9), BackgroundColor3 = color, BorderSizePixel = 0 }, h), 0.2)
	return h
end

function Icons.key(parent, x, y, color)
	local h = holder(parent, x, y, 18, 18)
	local k = new("Frame", { Size = UDim2.fromOffset(18, 18), BackgroundTransparency = 1, Rotation = -45 }, h)
	ring(k, 0, 5.5, 7, 7, 3.5, color, 1.6)
	new("Frame", { Position = UDim2.fromOffset(6.5, 8.2), Size = UDim2.fromOffset(11, 1.7), BackgroundColor3 = color, BorderSizePixel = 0 }, k)
	new("Frame", { Position = UDim2.fromOffset(12.8, 9.9), Size = UDim2.fromOffset(1.7, 3.4), BackgroundColor3 = color, BorderSizePixel = 0 }, k)
	new("Frame", { Position = UDim2.fromOffset(15.8, 9.9), Size = UDim2.fromOffset(1.7, 2.6), BackgroundColor3 = color, BorderSizePixel = 0 }, k)
	return h
end

function Icons.user(parent, x, y, color)
	local h = holder(parent, x, y, 18, 18, true)
	ring(h, 5, 1, 8, 8, 4, color, 1.7)
	ring(h, 1.5, 11, 15, 14, 7, color, 1.7)
	return h
end

function Icons.globe(parent, x, y, color)
	local h = holder(parent, x, y, 18, 18)
	ring(h, 1, 1, 16, 16, 8, color, 1.4)
	ring(h, 5.5, 1, 7, 16, 3.5, color, 1.2)
	new("Frame", { Position = UDim2.fromOffset(1, 8.5), Size = UDim2.fromOffset(16, 1), BackgroundColor3 = color, BorderSizePixel = 0 }, h)
	for _, yy in ipairs({ 4.5, 12.5 }) do
		new("Frame", { Position = UDim2.fromOffset(3, yy), Size = UDim2.fromOffset(12, 1), BackgroundColor3 = color, BackgroundTransparency = 0.4, BorderSizePixel = 0 }, h)
	end
	return h
end

function Icons.cross(parent, cx, cy, size, color)
	local h = new("Frame", {
		Position = UDim2.fromOffset(cx, cy), Size = UDim2.fromOffset(size, size), AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
	}, parent)
	for _, rot in ipairs({ 45, -45 }) do
		cornerS(new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(size * 1.35, 2), Rotation = rot, BackgroundColor3 = color, BorderSizePixel = 0,
		}, h), 0.5)
	end
	return h
end

function Icons.check(parent, color)
	local h = holder(parent, 0, 0, 18, 18)
	h.Size = UDim2.fromScale(1, 1)
	cornerS(new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(6.5, 10), Size = UDim2.fromOffset(6, 2),
		Rotation = 45, BackgroundColor3 = color, BorderSizePixel = 0,
	}, h), 0.5)
	cornerS(new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(10.5, 8), Size = UDim2.fromOffset(10, 2),
		Rotation = -50, BackgroundColor3 = color, BorderSizePixel = 0,
	}, h), 0.5)
	return h
end

local function tintIcon(h, col)
	for _, d in ipairs(h:GetDescendants()) do
		if d:IsA("UIStroke") then
			tween(d, 0.15, { Color = col })
		elseif d:IsA("ImageLabel") then
			tween(d, 0.15, { ImageColor3 = col })
		elseif d:IsA("Frame") and d.BackgroundTransparency < 1 and not d:GetAttribute("Hole") then
			tween(d, 0.15, { BackgroundColor3 = col })
		end
	end
end

function Icons.eye(parent, x, y, color, slashed)
	local h = holder(parent, x, y, 18, 18)
	ring(h, 0, 4, 18, 10, 5, color, 1.6)
	ring(h, 6, 6, 6, 6, 3, color, 1.5)
	cornerS(new("Frame", { Position = UDim2.fromOffset(8, 8), Size = UDim2.fromOffset(2, 2), BackgroundColor3 = color, BorderSizePixel = 0 }, h), 0.5)
	if slashed then
		cornerS(new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(9, 9), Size = UDim2.fromOffset(22, 2),
			Rotation = -45, BackgroundColor3 = color, BorderSizePixel = 0,
		}, h), 0.5)
	end
	return h
end

---------------------------------------------------------------------
-- ICONES VECTORIELLES DE L'ONGLET PROFILS (v1.8.8)
-- 100% Frames : ne dépendent ni d'images, ni de writefile, ni de getcustomasset
-- => affichage identique sur tous les appareils.
-- Repère 20x20, coordonnées au CENTRE des formes.
---------------------------------------------------------------------
local function vbox(parent, cx, cy, w, h, col, radius, rot, hole)
	local f = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(cx, cy),
		Size = UDim2.fromOffset(w, h), BackgroundColor3 = col, BorderSizePixel = 0,
		Rotation = rot or 0,
	}, parent)
	if radius and radius > 0 then corner(f, radius) end
	if hole then f:SetAttribute("Hole", true) end
	return f
end

local function vholder(parent)
	local h = holder(parent, 0, 0, 20, 20)
	h.AnchorPoint = Vector2.new(0.5, 0.5)
	h.Position = UDim2.fromScale(0.5, 0.5)
	return h
end

-- Gomme
function Icons.eraser(parent, color, holeCol)
	holeCol = holeCol or C.panel
	local h = vholder(parent)
	local body = vbox(h, 10, 8.5, 15, 8.5, color, 2.5, -38)
	vbox(body, 9.6, 4.25, 1.6, 8.5, holeCol, 0, 0, true)
	vbox(h, 10, 17.5, 16, 2, color, 1)
	return h
end

-- Plus dans un cercle plein
function Icons.plus(parent, color, holeCol)
	holeCol = holeCol or C.panel
	local h = vholder(parent)
	vbox(h, 10, 10, 19, 19, color, 9.5)
	vbox(h, 10, 10, 9, 2.2, holeCol, 1, 0, true)
	vbox(h, 10, 10, 2.2, 9, holeCol, 1, 0, true)
	return h
end

-- Charger (flèche vers le bas dans un bac)
function Icons.download(parent, color, holeCol)
	local h = vholder(parent)
	vbox(h, 10, 6.5, 2.2, 9.5, color, 1)
	vbox(h, 7.2, 11, 6.2, 2.2, color, 1, 45)
	vbox(h, 12.8, 11, 6.2, 2.2, color, 1, -45)
	vbox(h, 10, 17.5, 17, 2.2, color, 1)
	vbox(h, 2.4, 15, 2.2, 5.5, color, 1)
	vbox(h, 17.6, 15, 2.2, 5.5, color, 1)
	return h
end

-- Enregistrer (disquette)
function Icons.floppy(parent, color, holeCol)
	holeCol = holeCol or C.panel
	local h = vholder(parent)
	vbox(h, 10, 10, 17, 17, color, 3.5)
	vbox(h, 10, 5.2, 9, 4, holeCol, 1, 0, true)
	vbox(h, 10, 12.5, 7, 7, holeCol, 3.5, 0, true)
	return h
end

-- Modifier (crayon incliné)
function Icons.pencil(parent, color, holeCol)
	holeCol = holeCol or C.panel
	local h = vholder(parent)
	local c = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(10, 10),
		Size = UDim2.fromOffset(20, 20), BackgroundTransparency = 1, Rotation = 45,
	}, h)
	vbox(c, 10, 8.5, 4.4, 12.5, color, 1)
	vbox(c, 10, 15.3, 4.4, 4.4, color, 0, 45)
	vbox(c, 10, 4.2, 4.4, 1.2, holeCol, 0, 0, true)
	return h
end

-- Supprimer (corbeille)
function Icons.trash(parent, color, holeCol)
	holeCol = holeCol or C.panel
	local h = vholder(parent)
	vbox(h, 10, 3, 6.5, 2.2, color, 1)
	vbox(h, 10, 5.8, 17, 2.4, color, 1)
	vbox(h, 10, 12.8, 13, 10.5, color, 2.5)
	vbox(h, 7.6, 13.2, 1.5, 6, holeCol, 1, 0, true)
	vbox(h, 12.4, 13.2, 1.5, 6, holeCol, 1, 0, true)
	return h
end

---------------------------------------------------------------------
-- ICONES DU MENU
---------------------------------------------------------------------
local ACCENT = Color3.fromRGB(236, 239, 247)
local CAT_FONT = Enum.Font.Jura

local function fillDot(parent, x, y, s, color, isHole)
	local f = new("Frame", {
		Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(s, s),
		BackgroundColor3 = color, BorderSizePixel = 0,
	}, parent)
	cornerS(f, 0.5)
	if isHole then f:SetAttribute("Hole", true) end
	return f
end

function Icons.hubEye(parent, x, y, color, holeCol)
	holeCol = holeCol or C.bg
	local h = holder(parent, x, y, 18, 18)
	ring(h, 0.5, 3.5, 17, 11, 5.5, color, 2.2)
	fillDot(h, 5.2, 5.2, 7.6, color)
	fillDot(h, 7.4, 7.4, 3.2, holeCol, true)
	return h
end

function Icons.hubAim(parent, x, y, color, holeCol)
	local h = holder(parent, x, y, 18, 18)
	ring(h, 3.5, 3.5, 11, 11, 5.5, color, 1.8)
	local function barI(bx, by, bw, bh)
		cornerS(new("Frame", { Position = UDim2.fromOffset(bx, by), Size = UDim2.fromOffset(bw, bh), BackgroundColor3 = color, BorderSizePixel = 0 }, h), 0.5)
	end
	barI(8, 0, 2, 5.5)
	barI(8, 12.5, 2, 5.5)
	barI(0, 8, 5.5, 2)
	barI(12.5, 8, 5.5, 2)
	fillDot(h, 7.3, 7.3, 3.4, color)
	return h
end

function Icons.hubUser(parent, x, y, color, holeCol)
	local h = holder(parent, x, y, 18, 18, true)
	fillDot(h, 5.3, 0.8, 7.4, color)
	cornerS(new("Frame", { Position = UDim2.fromOffset(1.5, 10), Size = UDim2.fromOffset(15, 15), BackgroundColor3 = color, BorderSizePixel = 0 }, h), 0.5)
	return h
end

function Icons.hubFarm(parent, x, y, color, holeCol)
	local h = holder(parent, x, y, 18, 18)
	ring(h, 2, 2, 14, 14, 4, color, 1.5)
	cornerS(new("Frame", { Position = UDim2.fromOffset(7, 5), Size = UDim2.fromOffset(4, 8), BackgroundColor3 = color, BorderSizePixel = 0 }, h), 0.2)
	cornerS(new("Frame", { Position = UDim2.fromOffset(4, 11), Size = UDim2.fromOffset(10, 3), BackgroundColor3 = color, BorderSizePixel = 0 }, h), 0.2)
	return h
end

function Icons.hubGear(parent, x, y, color, holeCol)
	holeCol = holeCol or C.bg
	local h = holder(parent, x, y, 18, 18)
	fillDot(h, 3.3, 3.3, 11.4, color)
	for k = 0, 7 do
		local a = k * math.pi / 4
		cornerS(new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromOffset(9 + math.cos(a) * 7, 9 + math.sin(a) * 7),
			Size = UDim2.fromOffset(3.6, 4.2), Rotation = k * 45 + 90,
			BackgroundColor3 = color, BorderSizePixel = 0,
		}, h), 0.2)
	end
	fillDot(h, 6.6, 6.6, 4.8, holeCol, true)
	return h
end

function Icons.hubPalette(parent, x, y, color, holeCol)
	holeCol = holeCol or C.bg
	local h = holder(parent, x, y, 18, 18)
	cornerS(new("Frame", { Position = UDim2.fromOffset(0.3, 1.3), Size = UDim2.fromOffset(17.4, 15.4), BackgroundColor3 = color, BorderSizePixel = 0 }, h), 0.5)
	fillDot(h, 3.4, 6.4, 2.8, holeCol, true)
	fillDot(h, 6.8, 3.4, 2.8, holeCol, true)
	fillDot(h, 11.2, 3.6, 2.8, holeCol, true)
	fillDot(h, 13.8, 7.6, 2.8, holeCol, true)
	fillDot(h, 8.8, 10, 4.8, holeCol, true)
	return h
end

function Icons.previewSymbol(parent, x, y, color)
	local h = holder(parent, x, y, 18, 18)
	local screen = new("Frame", {
		Position = UDim2.fromOffset(1, 3), Size = UDim2.fromOffset(16, 11),
		BackgroundTransparency = 1,
	}, h)
	cornerS(screen, 0.25)
	stroke(screen, color, 1.4)
	fillDot(screen, 11, 3, 2, color)
	new("Frame", {
		Position = UDim2.fromOffset(7, 14), Size = UDim2.fromOffset(4, 2),
		BackgroundColor3 = color, BorderSizePixel = 0,
	}, h)
	new("Frame", {
		Position = UDim2.fromOffset(4, 16), Size = UDim2.fromOffset(10, 1),
		BackgroundColor3 = color, BorderSizePixel = 0,
	}, h)
	return h
end

local function imageIcon(assetName, fallback)
	return function(parent, x, y, color, holeCol)
		local asset = IconAssets[assetName]
		if not asset then return fallback(parent, x, y, color, holeCol) end
		local h = holder(parent, x, y, 18, 18)
		new("ImageLabel", {
			BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
			Image = asset, ImageColor3 = color, ScaleType = Enum.ScaleType.Fit,
		}, h)
		return h
	end
end

Icons.hubEye = imageIcon("eye", Icons.hubEye)
Icons.hubAim = imageIcon("aim", Icons.hubAim)
Icons.hubUser = imageIcon("user", Icons.hubUser)
Icons.hubFarm = imageIcon("farm", Icons.hubFarm)
Icons.hubGear = imageIcon("gear", Icons.hubGear)
Icons.hubPalette = imageIcon("palette", Icons.hubPalette)

do
	local fallbackEye = Icons.eye
	Icons.eye = function(parent, x, y, color, slashed)
		local asset = IconAssets.eye
		if not asset then return fallbackEye(parent, x, y, color, slashed) end
		local h = holder(parent, x, y, 18, 18)
		new("ImageLabel", {
			BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
			Image = asset, ImageColor3 = color, ScaleType = Enum.ScaleType.Fit,
		}, h)
		if slashed then
			cornerS(new("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(9, 9), Size = UDim2.fromOffset(22, 2),
				Rotation = -45, BackgroundColor3 = color, BorderSizePixel = 0,
			}, h), 0.5)
		end
		return h
	end
end

local function makeLogo(parent, size, pos, anchor)
	local h = new("Frame", {
		Size = UDim2.fromOffset(size, size), Position = pos, AnchorPoint = anchor or Vector2.new(0, 0),
		BackgroundTransparency = 1,
	}, parent)
	if LogoAsset then
		local img = new("ImageLabel", {
			BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
			Image = LogoAsset, ScaleType = Enum.ScaleType.Fit,
		}, h)
		corner(img, math.max(4, math.floor(size * 0.12)))
		return h
	end
	new("TextLabel", {
		BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Position = UDim2.fromOffset(2, 3),
		Text = "KR", Font = Enum.Font.GothamBlack, TextScaled = true,
		TextColor3 = Color3.fromRGB(60, 60, 66), Rotation = -4,
	}, h)
	local main = new("TextLabel", {
		BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
		Text = "KR", Font = Enum.Font.GothamBlack, TextScaled = true,
		TextColor3 = Color3.new(1, 1, 1), Rotation = -4,
	}, h)
	new("UIGradient", {
		Rotation = 90,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.55, Color3.fromRGB(190, 190, 198)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(110, 110, 118)),
		}),
	}, main)
	new("UIStroke", { Color = Color3.fromRGB(10, 10, 10), Thickness = 2 }, main)
	return h
end

---------------------------------------------------------------------
-- SYSTÈMES BRILLANTS & EXPIRATION
---------------------------------------------------------------------
local function isLifetimeVal(e)
	if e == nil or e == "Lifetime" then return true end
	if type(e) == "number" and e > 4102444800 then return true end
	return false
end

local function expiresText(e)
	if isLifetimeVal(e) then return S("lifetime") end
	if type(e) == "number" then
		return os.date("%d/%m/%Y", e)
	end
	return tostring(e)
end

local function rankTheme(rk)
	if rk == "free" then
		return { c0 = Color3.fromRGB(35, 145, 255), c1 = Color3.fromRGB(150, 225, 255), spark = Color3.fromRGB(190, 240, 255) }
	elseif rk == "standard" then
		return { c0 = Color3.fromRGB(35, 215, 95), c1 = Color3.fromRGB(165, 255, 195), spark = Color3.fromRGB(200, 255, 220) }
	end
	return { c0 = Color3.fromRGB(245, 195, 40), c1 = Color3.fromRGB(255, 250, 145), spark = Color3.fromRGB(255, 245, 170) }
end

local function startSparkles(parent, count, color, isOn)
	for _ = 1, count do
		local s = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(9, 9), BackgroundTransparency = 1, Visible = false, ZIndex = 6 }, parent)
		new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(9, 1.5), BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 6 }, s)
		new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(1.5, 9), BackgroundColor3 = color, BorderSizePixel = 0, ZIndex = 6 }, s)
		local sc = new("UIScale", { Scale = 0 }, s)
		task.spawn(function()
			task.wait(math.random() * 1.5)
			while alive(s) do
				if isOn() then
					s.Position = UDim2.fromScale(math.random(5, 95) / 100, math.random(10, 90) / 100)
					s.Rotation = math.random(0, 45)
					s.Visible = true
					tween(sc, 0.22, { Scale = 1 }, Enum.EasingStyle.Back)
					task.wait(0.26)
					tween(sc, 0.3, { Scale = 0 })
					task.wait(0.32)
					s.Visible = false
				end
				task.wait(0.3 + math.random() * 0.9)
			end
		end)
	end
end

local function applyRankShine(lbl, theme)
	lbl.TextColor3 = Color3.new(1, 1, 1)
	lbl.AutomaticSize = Enum.AutomaticSize.X
	lbl.Size = UDim2.fromOffset(0, lbl.Size.Y.Offset)
	local W = Color3.new(1, 1, 1)
	local grad = new("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, theme.c0),
			ColorSequenceKeypoint.new(0.3, theme.c1),
			ColorSequenceKeypoint.new(0.45, W),
			ColorSequenceKeypoint.new(0.55, W),
			ColorSequenceKeypoint.new(0.7, theme.c1),
			ColorSequenceKeypoint.new(1, theme.c0),
		}),
		Offset = Vector2.new(-1, 0),
	}, lbl)
	local st = new("UIStroke", { Color = theme.c0:Lerp(Color3.new(0, 0, 0), 0.6), Thickness = 1.2, Transparency = 1 }, lbl)
	task.spawn(function()
		repeat task.wait(0.1) until not alive(lbl) or lbl.TextTransparency < 0.9
		while alive(lbl) do
			grad.Offset = Vector2.new(-1, 0)
			tween(grad, 1.2, { Offset = Vector2.new(1, 0) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			tween(st, 0.6, { Transparency = 0.05 }, Enum.EasingStyle.Sine)
			task.wait(0.6)
			tween(st, 0.6, { Transparency = 0.35 }, Enum.EasingStyle.Sine)
			task.wait(1.6)
		end
	end)
	startSparkles(lbl, 3, theme.spark, function() return lbl.TextTransparency < 0.5 end)
end

local function makeExpiry(parent, pos, width, h, textSize)
	local root = new("Frame", { Position = pos, Size = UDim2.fromOffset(width, h), BackgroundTransparency = 1 }, parent)
	new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center }, root)
	local pre = new("TextLabel", { LayoutOrder = 1, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, h), Text = "", Font = Enum.Font.Gotham, TextSize = textSize, TextColor3 = C.muted }, root)
	local val = new("TextLabel", { LayoutOrder = 2, BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.X, Size = UDim2.fromOffset(0, h), Text = "", Font = Enum.Font.GothamBlack, TextSize = textSize, TextColor3 = Color3.new(1, 1, 1) }, root)
	local grad = new("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(235, 235, 240)),
			ColorSequenceKeypoint.new(0.38, Color3.fromRGB(250, 250, 255)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
			ColorSequenceKeypoint.new(0.62, Color3.fromRGB(250, 250, 255)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(235, 235, 240)),
		}),
		Offset = Vector2.new(-1, 0),
	}, val)
	local st = new("UIStroke", { Color = Color3.fromRGB(255, 255, 255), Thickness = 1, Transparency = 0.4 }, val)
	local self = { root = root }
	function self.set(prefixText, e)
		pre.Text = prefixText or ""
		val.Text = expiresText(e)
	end
	task.spawn(function()
		while alive(root) do
			grad.Offset = Vector2.new(-1, 0)
			tween(grad, 1.3, { Offset = Vector2.new(1, 0) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			tween(st, 0.65, { Transparency = 0.3 }, Enum.EasingStyle.Sine)
			task.wait(0.65)
			tween(st, 0.65, { Transparency = 0.6 }, Enum.EasingStyle.Sine)
			task.wait(2.2)
		end
	end)
	return self
end

local function maskKey(k)
	k = tostring(k or "")
	local n = utf8.len(k) or #k
	if n == 0 then return "—" end
	if n <= 8 then return string.rep("•", n) end
	return string.sub(k, 1, 4) .. "••••" .. string.sub(k, -4)
end

local function deviceId()
	local ok, id = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
	if ok and type(id) == "string" and id ~= "" then
		return id
	end
	return "N/A"
end

local function getGameName()
	local ok, n = pcall(function() return MarketplaceService:GetProductInfo(game.PlaceId).Name end)
	return (ok and n) or "Unknown"
end

local function isGameSupported()
	local low = string.lower(getGameName())
	for _, g in ipairs(Config.SupportedGames) do
		if string.find(low, string.lower(g), 1, true) then return true end
	end
	for _, id in ipairs(Config.SupportedPlaceIds) do
		if id == game.PlaceId then return true end
	end
	return false
end

local function httpPost(data)
	if not globalRequest then return end
	pcall(function() globalRequest(data) end)
end

local function openDiscord()
	if setclipboard then pcall(setclipboard, Config.DiscordLink) end
	httpPost({
		Url = "http://127.0.0.1:6463/rpc?v=1",
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json", ["Origin"] = "https://discord.com" },
		Body = HttpService:JSONEncode({
			cmd = "INVITE_BROWSER",
			args = { code = Config.DiscordCode },
			nonce = HttpService:GenerateGUID(false),
		}),
	})
end

---------------------------------------------------------------------
-- REQUÊTE HTTP ROBUSTE
---------------------------------------------------------------------
local function httpJson(path, payload, tries, delaySec)
	tries = tries or 6
	delaySec = delaySec or 5
	local lastCode = 0
	for attempt = 1, tries do
		local ok, res = pcall(globalRequest, {
			Url = Config.ApiBaseUrl .. path,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json",
				["Accept"] = "application/json",
			},
			Body = HttpService:JSONEncode(payload),
		})
		if ok and type(res) == "table" then
			local body = res.Body or res.body
			local code = tonumber(res.StatusCode or res.status_code or res.Status or res.status) or 0
			lastCode = code
			if type(body) == "string" and body ~= "" then
				local dok, dec = pcall(function() return HttpService:JSONDecode(body) end)
				if dok and type(dec) == "table" then
					return dec, code
				end
			end
			if code == 429 then
				return { error = "rate" }, code
			end
		end
		if attempt < tries then task.wait(delaySec) end
	end
	return nil, lastCode
end

---------------------------------------------------------------------
-- RESET HWID
---------------------------------------------------------------------
local function resetHwid(username)
	if not globalRequest or not username or username == "" then return false end
	local data = httpJson("/api/hwid-reset", {
		username = username,
		password = Session.password or "",
		hwid = deviceId(),
	}, 3, 4)
	if type(data) == "table" then
		return data.ok == true or data.success == true
	end
	return false
end

---------------------------------------------------------------------
-- GUI ROOT & FENÊTRE DE CONNEXION
---------------------------------------------------------------------
local player = Players.LocalPlayer
local pg = player:WaitForChild("PlayerGui")
local old = pg:FindFirstChild("KryptonLauncher")
if old then old:Destroy() end

local gui = new("ScreenGui", {
	Name = "KryptonLauncher", ResetOnSpawn = false, IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100,
}, pg)
setupGuiProtection(gui)

local window = new("Frame", {
	Size = UDim2.fromOffset(744, 466), AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = C.bg,
	BorderSizePixel = 0, ClipsDescendants = true,
}, gui)
corner(window, 14)
stroke(window, C.stroke, 1, 0.3)

local scale = new("UIScale", {}, window)
local function updateScale()
	local v = gui.AbsoluteSize
	scale.Scale = math.clamp(math.min(v.X / 800, v.Y / 600), 0.4, 1)
end
updateScale()
gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateScale)

---------------------------------------------------------------------
-- SYSTÈME ESP UNIVERSEL & SQUELETTE
---------------------------------------------------------------------
pcall(function()
	if getgenv then
		local g = getgenv()
		if g.KryptonESPConn then
			g.KryptonESPConn:Disconnect()
			g.KryptonESPConn = nil
		end
	end
end)
do
	local oldEsp = pg:FindFirstChild("KryptonESP")
	if oldEsp then oldEsp:Destroy() end
end

local espGui = new("ScreenGui", {
	Name = "KryptonESP", ResetOnSpawn = false, IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 90,
}, pg)
setupGuiProtection(espGui)

local espCount = new("TextLabel", {
	AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 12, 1, -12), Size = UDim2.fromOffset(180, 20),
	BackgroundTransparency = 1, Text = "", TextSize = 13, TextColor3 = Color3.new(1, 1, 1),
	Font = Enum.Font.GothamBold, TextStrokeTransparency = 0.4, Visible = false,
}, espGui)

local espObjs = {}
local ESP_WHITE = Color3.new(1, 1, 1)
local ESP_SKEL = Color3.fromRGB(150, 215, 255)

local function mkFrame(parent, col)
	return new("Frame", { BackgroundColor3 = col, BorderSizePixel = 0, Visible = false }, parent)
end
local function mkLine(parent, col)
	local f = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = col, BorderSizePixel = 0, Visible = false }, parent)
	cornerS(f, 0.5)
	stroke(f, Color3.fromRGB(10, 10, 15), 1.2, 0.3)
	return f
end
local function mkText(parent, size, col, font)
	return new("TextLabel", {
		AnchorPoint = Vector2.new(0.5, 0), Size = UDim2.fromOffset(220, 14), BackgroundTransparency = 1,
		Text = "", TextSize = size, TextColor3 = col, Font = font, TextStrokeTransparency = 0.4, Visible = false,
	}, parent)
end
local function setLine(f, x1, y1, x2, y2, th)
	local dx, dy = x2 - x1, y2 - y1
	f.Position = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2)
	f.Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy), th)
	f.Rotation = math.deg(math.atan2(dy, dx))
	f.Visible = true
end

local function removeEsp(plr)
	local d = espObjs[plr]
	if d then
		pcall(function() d.folder:Destroy() end)
		espObjs[plr] = nil
	end
end

local function hideEsp(d)
	for _, o in ipairs(d.all) do o.Visible = false end
	for _, jf in pairs(d.joints) do jf.Visible = false end
	d.smoothedJoints = {}
end

local function createEsp(plr)
	local folder = new("Folder", { Name = plr.Name }, espGui)
	local d = { folder = folder, all = {}, bones = {}, boneShadows = {}, joints = {}, smoothedJoints = {} }
	local function add(o)
		d.all[#d.all + 1] = o
		return o
	end
	d.box = add(new("Frame", { BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false }, folder))
	stroke(d.box, ESP_WHITE, 1.5)
	d.snap = add(mkLine(folder, ESP_WHITE))
	d.name = add(mkText(folder, 13, ESP_WHITE, Enum.Font.GothamBold))
	d.dist = add(mkText(folder, 11, Color3.fromRGB(200, 205, 215), Enum.Font.GothamMedium))
	d.dist.ZIndex = 3
	local distBg = add(new("Frame", { BackgroundColor3 = Color3.fromRGB(15, 15, 18), BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 2, Visible = false }, folder))
	corner(distBg, 3)
	d.distBg = distBg
	d.weapon = add(mkText(folder, 11, Color3.fromRGB(235, 215, 160), Enum.Font.GothamMedium))
	d.weapon.ZIndex = 3
	local weapBg = add(new("Frame", { BackgroundColor3 = Color3.fromRGB(15, 15, 18), BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 2, Visible = false }, folder))
	corner(weapBg, 3)
	d.weapBg = weapBg
	d.hbBg = add(mkFrame(folder, Color3.new(0, 0, 0)))
	d.hbBg.BackgroundTransparency = 0.4
	d.hb = add(mkFrame(folder, Color3.fromRGB(0, 255, 0)))
	d.hNum = add(new("TextLabel", { AnchorPoint = Vector2.new(1, 0.5), Size = UDim2.fromOffset(26, 12), BackgroundTransparency = 1, Text = "", Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Color3.fromRGB(110, 231, 140), TextXAlignment = Enum.TextXAlignment.Right, TextStrokeTransparency = 0.5, Visible = false }, folder))
	d.abBg = add(mkFrame(folder, Color3.new(0, 0, 0)))
	d.abBg.BackgroundTransparency = 0.4
	d.ab = add(mkFrame(folder, Color3.fromRGB(90, 160, 255)))
	d.aNum = add(new("TextLabel", { AnchorPoint = Vector2.new(1, 0.5), Size = UDim2.fromOffset(26, 12), BackgroundTransparency = 1, Text = "", Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Color3.fromRGB(130, 190, 255), TextXAlignment = Enum.TextXAlignment.Right, TextStrokeTransparency = 0.5, Visible = false }, folder))
	for i = 1, 24 do
		local b, sh = mkBone(folder, ESP_SKEL)
		d.bones[i] = add(b)
		d.boneShadows[i] = add(sh)
	end
	for _, jn in ipairs(JOINT_NAMES) do
		local jsz = (jn == "Head") and 7 or 4
		d.joints[jn] = add(mkJoint(folder, ESP_SKEL, jsz))
	end
	espObjs[plr] = d
	return d
end

local ARMOR_KEYS = { "Armor", "Armour", "Shield", "Kevlar", "Vest" }
local function readAttr(inst)
	if not inst then return nil end
	for _, k in ipairs(ARMOR_KEYS) do
		local a = inst:GetAttribute(k)
		if type(a) == "number" then return a end
	end
	return nil
end
local function getArmor(plr, char, hum)
	local v = readAttr(char) or readAttr(hum) or readAttr(plr)
	if not v then
		for _, k in ipairs(ARMOR_KEYS) do
			local o = char:FindFirstChild(k) or hum:FindFirstChild(k)
			if o and o:IsA("ValueBase") and type(o.Value) == "number" then
				v = o.Value
				break
			end
		end
	end
	if not v then return nil end
	local mx = char:GetAttribute("MaxArmor") or hum:GetAttribute("MaxArmor") or 100
	if type(mx) ~= "number" or mx <= 0 then mx = 100 end
	return math.clamp(v, 0, mx), mx
end

local function getWeapon(char)
	local t = char:FindFirstChildOfClass("Tool")
	return t and t.Name or nil
end

local function updatePlayer(plr, V, cam, vs, dt)
	local char = plr.Character
	local root = char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart)
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local d = espObjs[plr]
	if not (V.enable and root and hum and hum.Health > 0) then
		if d then removeEsp(plr) end
		return
	end
	local cf, size = char:GetBoundingBox()
	local topWorld = (cf.Position + Vector3.new(0, size.Y / 2 + 0.15, 0))
	local botWorld = (cf.Position - Vector3.new(0, size.Y / 2 + 0.1, 0))
	local top = cam:WorldToViewportPoint(topWorld)
	local bot = cam:WorldToViewportPoint(botWorld)
	local h = math.clamp(bot.Y - top.Y, 8, 3000)
	local w = h * 0.6
	local rootPos, onScreen = cam:WorldToViewportPoint(root.Position)
	if not (onScreen and rootPos.Z > 0) then
		if d then hideEsp(d) end
		return
	end
	if not d then d = createEsp(plr) end
	local cx = rootPos.X
	local x0 = math.floor(cx - w / 2 + 0.5)
	local y0 = math.floor(top.Y + 0.5)
	local x1, y1 = x0 + w, y0 + h
	local dist = (cam.CFrame.Position - root.Position).Magnitude
	if V.boxes then
		d.box.Position = UDim2.fromOffset(x0, y0)
		d.box.Size = UDim2.fromOffset(w, h)
		d.box.Visible = true
	else
		d.box.Visible = false
	end
	if V.snaplines then
		if V.snapPos == "Top" then
			setLine(d.snap, vs.X / 2, 0, cx, y0, 1.2)
		else
			setLine(d.snap, vs.X / 2, vs.Y, cx, y1, 1.2)
		end
	else
		d.snap.Visible = false
	end
	if V.names then
		d.name.Text = plr.DisplayName
		d.name.Position = UDim2.fromOffset(cx, y0 - 17)
		d.name.Visible = true
	else
		d.name.Visible = false
	end
	local av, amax = getArmor(plr, char, hum)
	local showArmor = V.armor and av ~= nil
	local showHealth = V.health
	local numX = showArmor and (x0 - 16) or (x0 - 10)
	local numYh, numYa
	if showHealth then
		local pct = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
		d.hbBg.Position = UDim2.fromOffset(x0 - 7, y0 - 1)
		d.hbBg.Size = UDim2.fromOffset(4, h + 2)
		d.hbBg.Visible = true
		d.hb.Position = UDim2.fromOffset(x0 - 6, y0 + h * (1 - pct))
		d.hb.Size = UDim2.fromOffset(2, h * pct)
		d.hb.BackgroundColor3 = Color3.fromRGB(255 * (1 - pct), 255 * pct, 0)
		d.hb.Visible = true
		numYh = math.clamp(y0 + h * (1 - pct), y0, y1 - 4)
	else
		d.hbBg.Visible = false
		d.hb.Visible = false
		d.hNum.Visible = false
	end
	if showArmor then
		local apct = math.clamp(av / amax, 0, 1)
		local abX = showHealth and (x0 - 13) or (x0 - 7)
		d.abBg.Position = UDim2.fromOffset(abX, y0 - 1)
		d.abBg.Size = UDim2.fromOffset(4, h + 2)
		d.abBg.Visible = true
		d.ab.Position = UDim2.fromOffset(abX + 1, y0 + h * (1 - apct))
		d.ab.Size = UDim2.fromOffset(2, h * apct)
		d.ab.Visible = true
		numYa = math.clamp(y0 + h * (1 - apct), y0, y1 - 4)
	else
		d.abBg.Visible = false
		d.ab.Visible = false
		d.aNum.Visible = false
	end
	if numYh and numYa and math.abs(numYa - numYh) < 11 then
		numYa = math.clamp(numYh + 11, y0, y1 + 8)
	end
	if numYh then
		d.hNum.Text = tostring(math.floor(hum.Health + 0.5))
		d.hNum.Position = UDim2.fromOffset(numX, numYh)
		d.hNum.Visible = true
	end
	if numYa then
		d.aNum.Text = tostring(math.floor(av + 0.5))
		d.aNum.Position = UDim2.fromOffset(numX, numYa)
		d.aNum.Visible = true
	end
	local by = y1 + 6
	if V.distance then
		d.dist.Text = math.floor(dist) .. "m"
		d.dist.Position = UDim2.fromOffset(cx, by)
		d.dist.Visible = true
		d.distBg.Position = UDim2.fromOffset(cx - 22, by)
		d.distBg.Size = UDim2.fromOffset(44, 14)
		d.distBg.Visible = true
		by += 16
	else
		d.dist.Visible = false
		d.distBg.Visible = false
	end
	local wname = V.weapon and getWeapon(char) or nil
	if wname then
		d.weapon.Text = wname
		d.weapon.Position = UDim2.fromOffset(cx, by)
		d.weapon.Visible = true
		d.weapBg.Position = UDim2.fromOffset(cx - 35, by)
		d.weapBg.Size = UDim2.fromOffset(70, 14)
		d.weapBg.Visible = true
	else
		d.weapon.Visible = false
		d.weapBg.Visible = false
	end
	if V.skeleton then
		local points = getSkeletonPoints(char)
		local skelTh = math.clamp(2.2 - dist / 150, 1.4, 2.2)
		local alpha = 1 - math.exp(-dt * 22)
		local shown = {}
		for name, pos in pairs(points) do
			local wp, ok = cam:WorldToViewportPoint(pos)
			if ok and wp.Z > 0 then
				local targetV2 = Vector2.new(wp.X, wp.Y)
				local currentV2 = d.smoothedJoints[name]
				if not currentV2 then
					currentV2 = targetV2
				else
					currentV2 = currentV2:Lerp(targetV2, alpha)
				end
				d.smoothedJoints[name] = currentV2
				shown[name] = { pos = currentV2, visible = true }
			else
				d.smoothedJoints[name] = nil
			end
		end
		for i = 1, #d.bones do
			local ln = d.bones[i]
			local sh = d.boneShadows[i]
			local boneData = SKELETON_BONES[i]
			if boneData then
				local j1 = shown[boneData[1]]
				local j2 = shown[boneData[2]]
				if j1 and j2 then
					setBoneLine(ln, sh, j1.pos.X, j1.pos.Y, j2.pos.X, j2.pos.Y, skelTh)
				else
					ln.Visible = false
					if sh then sh.Visible = false end
				end
			else
				ln.Visible = false
				if sh then sh.Visible = false end
			end
		end
		local jsz = math.clamp(math.floor(5 - dist / 80), 3, 5)
		for name, jf in pairs(d.joints) do
			local jInfo = shown[name]
			if jInfo then
				jf.Position = UDim2.fromOffset(jInfo.pos.X, jInfo.pos.Y)
				local sz = (name == "Head") and (jsz + 3) or jsz
				jf.Size = UDim2.fromOffset(sz, sz)
				jf.Visible = true
			else
				jf.Visible = false
			end
		end
	else
		d.smoothedJoints = {}
		for i = 1, #d.bones do
			d.bones[i].Visible = false
			if d.boneShadows[i] then d.boneShadows[i].Visible = false end
		end
		for _, jf in pairs(d.joints) do jf.Visible = false end
	end
end

Players.PlayerRemoving:Connect(removeEsp)

local lastRenderTick = os.clock()
local espConn = RunService.RenderStepped:Connect(function()
	if not Authed then return end
	local now = os.clock()
	local dt = now - lastRenderTick
	lastRenderTick = now
	dt = math.clamp(dt, 0.001, 0.1)

	local V = Settings.Visuals
	local cam = workspace.CurrentCamera
	if not cam then return end
	local vs = cam.ViewportSize
	if V.enable and V.count then
		espCount.Text = S("playersLbl") .. ": " .. #Players:GetPlayers()
		espCount.Visible = true
	else
		espCount.Visible = false
	end
	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			pcall(updatePlayer, plr, V, cam, vs, dt)
		end
	end
end)
pcall(function() if getgenv then getgenv().KryptonESPConn = espConn end end)

---------------------------------------------------------------------
-- PANNEAU DROIT (Radar & Logo KR)
---------------------------------------------------------------------
local right = new("Frame", {
	Position = UDim2.fromOffset(340, 0), Size = UDim2.fromOffset(404, 466),
	BackgroundColor3 = Color3.fromRGB(26, 26, 28), BorderSizePixel = 0,
}, window)
corner(right, 14)
new("UIGradient", {
	Rotation = 0,
	Color = ColorSequence.new(C.bg, Color3.fromRGB(28, 28, 30)),
	Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.3, 0.3), NumberSequenceKeypoint.new(1, 0),
	}),
}, right)

makeParticles(right, 404, 466, 18)

local CENTER = Vector2.new(553 - 340, 212)

local function circle(radius, transp)
	local f = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(CENTER.X, CENTER.Y),
		Size = UDim2.fromOffset(radius * 2, radius * 2), BackgroundTransparency = 1,
	}, right)
	corner(f, radius)
	stroke(f, Color3.fromRGB(80, 80, 86), 1, transp)
	return f
end
local c1 = circle(138, 0.5)
local c2 = circle(85, 0.65)

task.spawn(function()
	while alive(right) do
		tween(c1, 2, { Size = UDim2.fromOffset(290, 290) })
		tween(c2, 2, { Size = UDim2.fromOffset(180, 180) })
		task.wait(2)
		tween(c1, 2, { Size = UDim2.fromOffset(276, 276) })
		tween(c2, 2, { Size = UDim2.fromOffset(170, 170) })
		task.wait(2)
	end
end)

local sweep = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(CENTER.X, CENTER.Y),
	Size = UDim2.fromOffset(276, 276), BackgroundTransparency = 1,
}, right)
corner(sweep, 138)
stroke(sweep, Color3.new(1, 1, 1), 2, 0)
local sweepGrad = new("UIGradient", {
	Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.55, 1),
		NumberSequenceKeypoint.new(0.8, 0.45), NumberSequenceKeypoint.new(1, 0.05),
	}),
}, sweep:FindFirstChildOfClass("UIStroke"))

task.spawn(function()
	while alive(right) do
		local r = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(CENTER.X, CENTER.Y),
			Size = UDim2.fromOffset(80, 80), BackgroundTransparency = 1,
		}, right)
		cornerS(r, 0.5)
		local s = stroke(r, Color3.fromRGB(200, 200, 210), 1.5, 0.35)
		tween(r, 2.6, { Size = UDim2.fromOffset(276, 276) })
		tween(s, 2.6, { Transparency = 1 })
		task.wait(1.4)
	end
end)

local dot = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(6, 6),
	BackgroundColor3 = Color3.fromRGB(235, 235, 240), BorderSizePixel = 0,
}, right)
cornerS(dot, 0.5)
new("UIStroke", { Color = Color3.new(1, 1, 1), Transparency = 0.7, Thickness = 3 }, dot)

local dot2 = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(4, 4),
	BackgroundColor3 = Color3.fromRGB(170, 170, 180), BorderSizePixel = 0,
}, right)
cornerS(dot2, 0.5)
new("UIStroke", { Color = Color3.new(1, 1, 1), Transparency = 0.8, Thickness = 2 }, dot2)

local angle = math.rad(100)
local sweepConn
sweepConn = RunService.RenderStepped:Connect(function(dt)
	if not alive(right) then sweepConn:Disconnect() return end
	angle += dt * 0.7
	dot.Position = UDim2.fromOffset(CENTER.X + math.cos(angle) * 138, CENTER.Y + math.sin(angle) * 138)
	dot2.Position = UDim2.fromOffset(CENTER.X + math.cos(-angle * 1.6 + 2) * 85, CENTER.Y + math.sin(-angle * 1.6 + 2) * 85)
	sweepGrad.Rotation = (sweepGrad.Rotation + dt * 80) % 360
end)

local glow = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(CENTER.X, CENTER.Y),
	Size = UDim2.fromOffset(180, 180), BackgroundColor3 = Color3.new(1, 1, 1),
	BackgroundTransparency = 0.94, BorderSizePixel = 0,
}, right)
cornerS(glow, 0.5)
task.spawn(function()
	while alive(right) do
		tween(glow, 1.6, { BackgroundTransparency = 0.88, Size = UDim2.fromOffset(205, 205) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		task.wait(1.6)
		tween(glow, 1.6, { BackgroundTransparency = 0.96, Size = UDim2.fromOffset(170, 170) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		task.wait(1.6)
	end
end)

local bigLogo = makeLogo(right, 130, UDim2.fromOffset(CENTER.X, CENTER.Y), Vector2.new(0.5, 0.5))

task.spawn(function()
	local t = 0
	while alive(right) do
		t += task.wait()
		bigLogo.Position = UDim2.fromOffset(CENTER.X, CENTER.Y + math.sin(t * 2) * 5)
		bigLogo.Rotation = math.sin(t * 1.5) * 2
		glow.Position = bigLogo.Position
	end
end)

label(right, Config.Name, 16, UDim2.fromOffset(CENTER.X - 100, 421), UDim2.fromOffset(200, 22), C.text, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
label(right, Config.Subtitle, 10, UDim2.fromOffset(CENTER.X - 100, 444), UDim2.fromOffset(200, 14), C.muted, Enum.Font.GothamMedium, Enum.TextXAlignment.Center)

---------------------------------------------------------------------
-- BARRE DU HAUT & ELEMENTS LOGIN
---------------------------------------------------------------------
local topbar = new("Frame", { Size = UDim2.fromOffset(744, 60), BackgroundTransparency = 1 }, window)
makeDraggable(window, topbar)

local closeBtn = new("TextButton", {
	Position = UDim2.fromOffset(704, 16), Size = UDim2.fromOffset(32, 32), BackgroundTransparency = 1,
	Text = "", AutoButtonColor = false, ZIndex = 5,
}, window)
local closeX = Icons.cross(closeBtn, 16, 16, 11, C.muted)
local function tintX(col)
	for _, f in ipairs(closeX:GetChildren()) do
		if f:IsA("Frame") then tween(f, 0.15, { BackgroundColor3 = col }) end
	end
end
closeBtn.MouseEnter:Connect(function() tintX(C.text); tween(closeX, 0.3, { Rotation = 90 }, Enum.EasingStyle.Back) end)
closeBtn.MouseLeave:Connect(function() tintX(C.muted); tween(closeX, 0.3, { Rotation = 0 }, Enum.EasingStyle.Back) end)
closeBtn.MouseButton1Click:Connect(function()
	tween(window, 0.3, { Size = UDim2.fromOffset(744, 0) }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	task.wait(0.32)
	gui:Destroy()
end)

makeLogo(window, 32, UDim2.fromOffset(24, 20))

local discordBtn = new("TextButton", {
	Position = UDim2.fromOffset(170, 22), Size = UDim2.fromOffset(30, 30),
	BackgroundColor3 = C.discord, Text = "", AutoButtonColor = false, ZIndex = 3, ClipsDescendants = true,
}, window)
corner(discordBtn, 8)

if DiscordAsset then
	local dImg = new("ImageLabel", {
		BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
		Image = DiscordAsset, ScaleType = Enum.ScaleType.Crop, ZIndex = 4,
	}, discordBtn)
	corner(dImg, 8)
end

discordBtn.MouseEnter:Connect(function()
	tween(discordBtn, 0.2, { BackgroundColor3 = Color3.fromRGB(112, 124, 255), Size = UDim2.fromOffset(34, 34), Position = UDim2.fromOffset(168, 20), Rotation = 6 }, Enum.EasingStyle.Back)
end)
discordBtn.MouseLeave:Connect(function()
	tween(discordBtn, 0.2, { BackgroundColor3 = C.discord, Size = UDim2.fromOffset(30, 30), Position = UDim2.fromOffset(170, 22), Rotation = 0 }, Enum.EasingStyle.Back)
end)
Icons.globe(window, 212, 27, C.muted).ZIndex = 3

local langBtns, langStrokes = {}, {}
local function langButton(code, x)
	local b = new("TextButton", {
		Position = UDim2.fromOffset(x, 23), Size = UDim2.fromOffset(32, 26), BackgroundColor3 = C.field,
		Text = code, Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = C.muted,
		AutoButtonColor = false, ZIndex = 3,
	}, window)
	corner(b, 6)
	langStrokes[code] = stroke(b, C.stroke, 1)
	langBtns[code] = b
	b.MouseEnter:Connect(function() tween(b, 0.15, { BackgroundColor3 = Color3.fromRGB(30, 30, 34) }) end)
	b.MouseLeave:Connect(function() tween(b, 0.15, { BackgroundColor3 = C.field }) end)
end
langButton("FR", 238)
langButton("EN", 276)

local isSignup = false

local Y_USER, Y_PASS = 104, 156
local Y_REMEMBER, Y_STATUS, Y_SUBMIT, Y_GETKEY = 206, 238, 258, 308

local leftContainer = new("Frame", {
	Position = UDim2.fromOffset(24, 75), Size = UDim2.fromOffset(300, 380),
	BackgroundTransparency = 1,
}, window)

local title = label(leftContainer, "", 22, UDim2.fromOffset(0, 0), UDim2.fromOffset(300, 30), C.text, Enum.Font.GothamBlack)
local subtitle = label(leftContainer, "", 11, UDim2.fromOffset(0, 32), UDim2.fromOffset(300, 16), C.muted, Enum.Font.Gotham)

local tabContainer = new("Frame", {
	Position = UDim2.fromOffset(0, 56), Size = UDim2.fromOffset(300, 36), BackgroundColor3 = C.tabBg,
}, leftContainer)
corner(tabContainer, 8)
stroke(tabContainer, C.stroke, 1)

local tabPill = new("Frame", {
	Position = UDim2.fromOffset(3, 3), Size = UDim2.fromOffset(144, 30), BackgroundColor3 = C.tabSel,
	BorderSizePixel = 0, ZIndex = 1,
}, tabContainer)
corner(tabPill, 6)

local function makeTab(x, active)
	local b = new("TextButton", {
		Position = UDim2.fromOffset(x, 3), Size = UDim2.fromOffset(144, 30), BackgroundTransparency = 1,
		Text = "", Font = Enum.Font.GothamBold, TextSize = 12,
		TextColor3 = active and C.text or C.muted, AutoButtonColor = false, ZIndex = 2,
	}, tabContainer)
	corner(b, 6)
	return b
end

local tabSignin = makeTab(3, true)
local tabSignup = makeTab(153, false)

local function field(y, iconFn)
	local f = new("Frame", {
		Position = UDim2.fromOffset(0, y), Size = UDim2.fromOffset(300, 40), BackgroundColor3 = C.field, BorderSizePixel = 0,
	}, leftContainer)
	corner(f, 8)
	local st = stroke(f, C.stroke, 1)
	iconFn(f, 12, 11, C.muted)
	local box = new("TextBox", {
		BackgroundTransparency = 1, Position = UDim2.fromOffset(38, 0), Size = UDim2.fromOffset(250, 40),
		Text = "", PlaceholderText = "", PlaceholderColor3 = C.muted, TextColor3 = C.text,
		Font = Enum.Font.GothamMedium, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
	}, f)
	box.Focused:Connect(function()
		tween(st, 0.15, { Color = Color3.fromRGB(110, 110, 120), Thickness = 1.6 })
		tween(f, 0.15, { BackgroundColor3 = Color3.fromRGB(23, 23, 26) })
	end)
	box.FocusLost:Connect(function()
		tween(st, 0.15, { Color = C.stroke, Thickness = 1 })
		tween(f, 0.15, { BackgroundColor3 = C.field })
	end)
	return f, box, st
end

local maskUpdaters = {}
local function secretField(y, iconFn, phFn)
	local f, box, st = field(y, iconFn)
	box.Size = UDim2.fromOffset(214, 40)
	local hidden = true
	local overlay = new("TextLabel", {
		BackgroundTransparency = 1, Position = UDim2.fromOffset(38, 0), Size = UDim2.fromOffset(214, 40),
		Text = "", Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = C.text,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 2,
	}, f)
	local function updateMask()
		if hidden then
			box.TextTransparency = 1
			box.PlaceholderText = ""
			local n = utf8.len(box.Text) or #box.Text
			if n == 0 then
				overlay.Text = phFn()
				overlay.TextColor3 = C.muted
			else
				overlay.Text = string.rep("•", n)
				overlay.TextColor3 = C.text
			end
		else
			box.TextTransparency = 0
			box.PlaceholderText = phFn()
			overlay.Text = ""
		end
	end
	box:GetPropertyChangedSignal("Text"):Connect(updateMask)
	local eyeBtn = new("TextButton", {
		Position = UDim2.fromOffset(262, 5), Size = UDim2.fromOffset(30, 30), BackgroundTransparency = 1,
		Text = "", AutoButtonColor = false, ZIndex = 4,
	}, f)
	local eyeIcon
	local function drawEye()
		if eyeIcon then eyeIcon:Destroy() end
		eyeIcon = Icons.eye(eyeBtn, 6, 6, C.muted, hidden)
		eyeIcon.ZIndex = 4
	end
	drawEye()
	eyeBtn.MouseEnter:Connect(function() tintIcon(eyeIcon, C.text) end)
	eyeBtn.MouseLeave:Connect(function() tintIcon(eyeIcon, C.muted) end)
	eyeBtn.MouseButton1Click:Connect(function()
		hidden = not hidden
		drawEye()
		updateMask()
	end)
	maskUpdaters[#maskUpdaters + 1] = updateMask
	updateMask()
	return f, box, st
end

local userField, userBox, userStroke = field(Y_USER, Icons.user)
local passField, passBox, passStroke = secretField(Y_PASS, Icons.lock, function() return S("passPh") end)

local remember = true
local rememberBtn = new("TextButton", {
	Position = UDim2.fromOffset(0, Y_REMEMBER), Size = UDim2.fromOffset(300, 24), BackgroundTransparency = 1,
	Text = "", AutoButtonColor = false, ZIndex = 3,
}, leftContainer)
local rBox = new("Frame", {
	AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromOffset(6, 12), Size = UDim2.fromOffset(18, 18),
	BackgroundColor3 = C.text, BorderSizePixel = 0,
}, rememberBtn)
corner(rBox, 5)
local rStroke = stroke(rBox, C.text, 1)
local rMark = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(18, 18), BackgroundTransparency = 1,
}, rBox)
Icons.check(rMark, Color3.new(0, 0, 0))
local rMarkScale = new("UIScale", { Scale = 1 }, rMark)
local rememberLbl = label(rememberBtn, "", 12, UDim2.fromOffset(34, 0), UDim2.fromOffset(250, 24), Color3.fromRGB(200, 200, 205), Enum.Font.Gotham)

local function setRemember(on, instant)
	remember = on
	local bg = on and C.text or C.field
	local sk = on and C.text or C.stroke
	if instant then
		rBox.BackgroundColor3 = bg
		rStroke.Color = sk
		rMarkScale.Scale = on and 1 or 0
	else
		tween(rBox, 0.2, { BackgroundColor3 = bg })
		tween(rStroke, 0.2, { Color = sk })
		tween(rMarkScale, 0.25, { Scale = on and 1 or 0 }, on and Enum.EasingStyle.Back or Enum.EasingStyle.Quad)
	end
end
setRemember(true, true)
rememberBtn.MouseButton1Click:Connect(function() setRemember(not remember) end)
rememberBtn.MouseEnter:Connect(function() tween(rememberLbl, 0.15, { TextColor3 = C.text }) end)
rememberBtn.MouseLeave:Connect(function() tween(rememberLbl, 0.15, { TextColor3 = Color3.fromRGB(200, 200, 205) }) end)

local status = label(leftContainer, "", 11, UDim2.fromOffset(0, Y_STATUS), UDim2.fromOffset(300, 16), C.err, Enum.Font.GothamMedium)

local submit = new("TextButton", {
	Position = UDim2.fromOffset(0, Y_SUBMIT), Size = UDim2.fromOffset(300, 42), BackgroundColor3 = Color3.fromRGB(250, 250, 250),
	Text = "", AutoButtonColor = false, ClipsDescendants = true,
}, leftContainer)
corner(submit, 10)
local submitText = new("TextLabel", {
	BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Font = Enum.Font.GothamBold, TextSize = 13,
	TextColor3 = Color3.new(0, 0, 0), Text = "",
}, submit)

local shine = new("Frame", {
	Size = UDim2.fromOffset(40, 70), Position = UDim2.fromOffset(-60, -14), Rotation = 20,
	BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0.55, BorderSizePixel = 0,
}, submit)
new("UIGradient", {
	Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1),
	}),
}, shine)
task.spawn(function()
	while alive(submit) do
		shine.Position = UDim2.fromOffset(-60, -14)
		tween(shine, 0.9, { Position = UDim2.fromOffset(340, -14) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
		task.wait(4)
	end
end)

submit.MouseEnter:Connect(function() tween(submit, 0.15, { BackgroundColor3 = Color3.fromRGB(225, 225, 228) }) end)
submit.MouseLeave:Connect(function()
	tween(submit, 0.15, { BackgroundColor3 = Color3.fromRGB(250, 250, 250), Size = UDim2.fromOffset(300, 42), Position = UDim2.fromOffset(0, Y_SUBMIT) })
end)
submit.MouseButton1Down:Connect(function()
	tween(submit, 0.1, { Size = UDim2.fromOffset(292, 38), Position = UDim2.fromOffset(4, Y_SUBMIT + 2) })
end)
submit.MouseButton1Up:Connect(function()
	tween(submit, 0.2, { Size = UDim2.fromOffset(300, 42), Position = UDim2.fromOffset(0, Y_SUBMIT) }, Enum.EasingStyle.Back)
end)

local getKeyBtn = new("TextButton", {
	Position = UDim2.fromOffset(0, Y_GETKEY), Size = UDim2.fromOffset(300, 36), BackgroundColor3 = C.discord,
	Text = "", AutoButtonColor = false, Visible = false, ClipsDescendants = true,
}, leftContainer)
corner(getKeyBtn, 8)

local getKeyText = new("TextLabel", {
	BackgroundTransparency = 1, Position = UDim2.fromOffset(36, 0), Size = UDim2.fromOffset(254, 36),
	Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = C.text, Text = "",
	TextXAlignment = Enum.TextXAlignment.Left,
}, getKeyBtn)

if DiscordAsset then
	local btnDImg = new("ImageLabel", {
		Position = UDim2.fromOffset(12, 10), Size = UDim2.fromOffset(16, 16),
		BackgroundTransparency = 1, Image = DiscordAsset, ScaleType = Enum.ScaleType.Crop,
	}, getKeyBtn)
	corner(btnDImg, 4)
end

getKeyBtn.MouseEnter:Connect(function() tween(getKeyBtn, 0.15, { BackgroundColor3 = Color3.fromRGB(105, 116, 255) }) end)
getKeyBtn.MouseLeave:Connect(function() tween(getKeyBtn, 0.15, { BackgroundColor3 = C.discord }) end)

local gameState = nil
local badge = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromOffset(CENTER.X, 388),
	Size = UDim2.fromOffset(190, 28), BackgroundColor3 = C.panel, BorderSizePixel = 0,
}, right)
corner(badge, 14)
local badgeStroke = stroke(badge, C.stroke, 1)
local badgeDot = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(18, 14),
	Size = UDim2.fromOffset(8, 8), BackgroundColor3 = C.muted, BorderSizePixel = 0,
}, badge)
new("UICorner", { CornerRadius = UDim.new(0.5, 0) }, badgeDot)
local badgeText = label(badge, "", 11, UDim2.fromOffset(34, 0), UDim2.fromOffset(150, 28), C.text, Enum.Font.GothamMedium)

task.spawn(function()
	while alive(badge) do
		local r = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(18, 14),
			Size = UDim2.fromOffset(8, 8), BackgroundTransparency = 1,
		}, badge)
		new("UICorner", { CornerRadius = UDim.new(0.5, 0) }, r)
		local s = stroke(r, badgeDot.BackgroundColor3, 1.5, 0.2)
		tween(r, 1.2, { Size = UDim2.fromOffset(22, 22) })
		tween(s, 1.2, { Transparency = 1 })
		task.delay(1.3, function() r:Destroy() end)
		task.wait(1.8)
	end
end)

local function updateGameBadge()
	local col, txt, st = C.muted, "...", C.stroke
	if gameState == true then
		col, txt, st = C.good, S("gameSupported"), Color3.fromRGB(46, 80, 56)
	elseif gameState == false then
		col, txt, st = C.err, S("gameUnsupported"), Color3.fromRGB(100, 48, 48)
	end
	tween(badgeDot, 0.3, { BackgroundColor3 = col })
	tween(badgeStroke, 0.3, { Color = st })
	badgeText.Text = txt
end

task.spawn(function()
	gameState = isGameSupported()
	updateGameBadge()
end)

do
	local final = badge.Position
	badge.Position = UDim2.new(final.X.Scale, final.X.Offset, final.Y.Scale, final.Y.Offset + 18)
	task.delay(0.9, function()
		tween(badge, 0.5, { Position = final }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	end)
end

---------------------------------------------------------------------
-- KRYPTON HUB
---------------------------------------------------------------------
local function openHub(username, rank, expires, expiresAt)
	Authed = true
	local hub = new("Frame", {
		Size = UDim2.fromOffset(0, 0), AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = C.bg,
		BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 50,
	}, gui)
	corner(hub, 14)
	stroke(hub, C.stroke, 1, 0.3)

	local toastFrame = new("Frame", {
		AnchorPoint = Vector2.new(1, 0), Position = UDim2.fromOffset(600, 8), Size = UDim2.fromOffset(220, 36),
		BackgroundColor3 = Color3.fromRGB(8, 8, 9), BorderSizePixel = 0, ZIndex = 70, Visible = false,
	}, hub)
	corner(toastFrame, 8)
	stroke(toastFrame, Color3.fromRGB(30, 30, 34), 1)
	local toastBar = new("Frame", {
		Position = UDim2.fromOffset(12, 30), Size = UDim2.fromOffset(0, 2), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 71,
	}, toastFrame)
	new("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
		})
	}, toastBar)
	local toastTitleLbl = label(toastFrame, "", 12, UDim2.fromOffset(12, 6), UDim2.fromOffset(120, 16), Color3.new(1, 1, 1), Enum.Font.GothamBold)
	toastTitleLbl.ZIndex = 72
	toastTitleLbl.TextTruncate = Enum.TextTruncate.AtEnd
	local toastLbl = label(toastFrame, "", 11, UDim2.fromOffset(132, 6), UDim2.fromOffset(76, 16), Color3.new(1, 1, 1), Enum.Font.GothamBold, Enum.TextXAlignment.Right)
	toastLbl.ZIndex = 72
	toastLbl.TextTruncate = Enum.TextTruncate.AtEnd
	local toastToken = 0
	local function showToast(titleText, statusText)
		toastToken += 1
		local currentToken = toastToken
		toastTitleLbl.Text = titleText
		toastLbl.Text = statusText
		toastBar.Size = UDim2.fromOffset(0, 2)
		toastFrame.Visible = true
		toastFrame.Position = UDim2.fromOffset(600, -30)
		tween(toastFrame, 0.3, { Position = UDim2.fromOffset(600, 8) }, Enum.EasingStyle.Back)
		tween(toastBar, 2, { Size = UDim2.fromOffset(196, 2) })
		task.delay(2.2, function()
			if toastToken == currentToken then
				tween(toastFrame, 0.3, { Position = UDim2.fromOffset(600, -30) })
				task.wait(0.35)
				if toastToken == currentToken then toastFrame.Visible = false end
			end
		end)
	end

	local hs = new("UIScale", {}, hub)
	local function us()
		local v = gui.AbsoluteSize
		hs.Scale = math.clamp(math.min(v.X / 720, v.Y / 480), 0.4, 1)
	end
	us()
	gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(us)
	makeParticles(hub, 640, 400, 14)
	local header = new("Frame", { Size = UDim2.fromOffset(640, 56), BackgroundTransparency = 1 }, hub)
	makeDraggable(hub, header)
	local hubLogo = makeLogo(hub, 36, UDim2.fromOffset(16, 10))
	local hubTitle = new("TextLabel", {
		BackgroundTransparency = 1, Position = UDim2.fromOffset(40, 10), Size = UDim2.fromOffset(180, 36),
		Text = "Krypton Hub", Font = Enum.Font.Michroma, TextSize = 16, TextColor3 = C.text,
		TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
		TextTransparency = 1,
	}, hub)
	tween(hubTitle, 0.6, { TextTransparency = 0, Position = UDim2.fromOffset(60, 10) }, Enum.EasingStyle.Quint)
	label(hub, "v1.8", 10, UDim2.fromOffset(210, 25), UDim2.fromOffset(40, 14), C.muted, Enum.Font.Gotham)
	local sep = new("Frame", { Position = UDim2.fromOffset(0, 56), Size = UDim2.fromOffset(0, 1), BackgroundColor3 = C.stroke, BorderSizePixel = 0 }, hub)
	task.delay(0.3, function() tween(sep, 0.8, { Size = UDim2.fromOffset(640, 1) }, Enum.EasingStyle.Quint) end)
	task.spawn(function()
		local t = 0
		while alive(hub) do
			t += task.wait()
			hubLogo.Rotation = math.sin(t * 1.6) * 4
		end
	end)
	local setHub
	local hClose = new("TextButton", {
		Position = UDim2.fromOffset(596, 12), Size = UDim2.fromOffset(32, 32), BackgroundTransparency = 1,
		Text = "", AutoButtonColor = false, ZIndex = 5,
	}, hub)
	local hX = Icons.cross(hClose, 16, 16, 11, C.muted)
	hClose.MouseEnter:Connect(function()
		for _, f in ipairs(hX:GetChildren()) do if f:IsA("Frame") then tween(f, 0.15, { BackgroundColor3 = C.text }) end end
		tween(hX, 0.3, { Rotation = 90 }, Enum.EasingStyle.Back)
	end)
	hClose.MouseLeave:Connect(function()
		for _, f in ipairs(hX:GetChildren()) do if f:IsA("Frame") then tween(f, 0.15, { BackgroundColor3 = C.muted }) end end
		tween(hX, 0.3, { Rotation = 0 }, Enum.EasingStyle.Back)
	end)
	hClose.MouseButton1Click:Connect(function() setHub(false) end)
	local cats = {
		{ key = "catVisuals", icon = Icons.hubEye },
		{ key = "catAssist", icon = Icons.hubAim },
		{ key = "catPlayer", icon = Icons.hubUser },
		{ key = "catFarm", icon = Icons.hubFarm },
		{ key = "catMisc", icon = Icons.hubGear },
		{ key = "catCustom", icon = Icons.hubPalette },
	}
	local TXT_OFF = Color3.fromRGB(150, 150, 158)
	local TXT_HOVER = Color3.fromRGB(205, 205, 212)
	local side = new("Frame", { Position = UDim2.fromOffset(14, 66), Size = UDim2.fromOffset(150, 280), BackgroundTransparency = 1 }, hub)
	local pill = new("Frame", { Size = UDim2.fromOffset(150, 36), BackgroundColor3 = C.tabSel, BorderSizePixel = 0 }, side)
	corner(pill, 6)
	local pillStroke = stroke(pill, C.stroke, 1)
	local pillBar = new("Frame", { Position = UDim2.fromOffset(0, 5), Size = UDim2.fromOffset(3, 26), BackgroundColor3 = ACCENT, BorderSizePixel = 0 }, pill)
	corner(pillBar, 2)
	task.spawn(function()
		while alive(hub) do
			tween(pillBar, 0.9, { Size = UDim2.fromOffset(3, 18), Position = UDim2.fromOffset(0, 9) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			tween(pillStroke, 0.9, { Transparency = 0.5 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			task.wait(0.9)
			tween(pillBar, 0.9, { Size = UDim2.fromOffset(3, 26), Position = UDim2.fromOffset(0, 5) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			tween(pillStroke, 0.9, { Transparency = 0 }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			task.wait(0.9)
		end
	end)
	local pages = {}
	local trList, onLang = {}, {}
	local applyLang
	local refreshVisualsUI
	local refreshAdminUI
	local refreshDD = function() end
	local loadedProfileName = nil
	local function reg(lbl, key)
		trList[#trList + 1] = { lbl = lbl, key = key }
		lbl.Text = S(key)
		return lbl
	end
	local function comingSoon(catKey)
		local pgC = new("CanvasGroup", {
			Position = UDim2.fromOffset(180, 72), Size = UDim2.fromOffset(446, 310),
			BackgroundTransparency = 1, Visible = false,
		}, hub)
		pages[#pages + 1] = pgC
		local catDef
		for _, c in ipairs(cats) do if c.key == catKey then catDef = c break end end
		local ico = catDef.icon(pgC, 0, 0, Color3.fromRGB(80, 80, 88), C.bg)
		ico.AnchorPoint = Vector2.new(0.5, 0.5)
		ico.Position = UDim2.fromOffset(223, 104)
		new("UIScale", { Scale = 2.6 }, ico)
		reg(label(pgC, "", 22, UDim2.fromOffset(0, 156), UDim2.fromOffset(446, 28), C.text, CAT_FONT, Enum.TextXAlignment.Center), catKey)
		reg(label(pgC, "", 12, UDim2.fromOffset(0, 184), UDim2.fromOffset(446, 18), C.muted, Enum.Font.Gotham, Enum.TextXAlignment.Center), "comingSoonTitle")
		task.spawn(function()
			while alive(ico) do
				tween(ico, 1.4, { Position = UDim2.fromOffset(223, 98) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
				task.wait(1.4)
				tween(ico, 1.4, { Position = UDim2.fromOffset(223, 110) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
				task.wait(1.4)
			end
		end)
	end
	local SUB_W = 88
	local function makeSubTabs(parent, keys, callback)
		local subBar = new("Frame", {
			Position = UDim2.fromOffset(0, 32), Size = UDim2.fromOffset(4 + #keys * SUB_W, 28),
			BackgroundColor3 = C.tabBg, BorderSizePixel = 0,
		}, parent)
		corner(subBar, 8)
		stroke(subBar, C.stroke, 1)
		local subPill = new("Frame", {
			Position = UDim2.fromOffset(2, 2), Size = UDim2.fromOffset(SUB_W, 24),
			BackgroundColor3 = C.tabSel, BorderSizePixel = 0, ZIndex = 1,
		}, subBar)
		corner(subPill, 6)
		local subBtns = {}
		local function showSubTab(idx)
			callback(idx)
			for i, b in ipairs(subBtns) do
				tween(b, 0.2, { TextColor3 = (i == idx) and C.text or C.muted })
			end
			tween(subPill, 0.3, { Position = UDim2.fromOffset(2 + (idx - 1) * SUB_W, 2) }, Enum.EasingStyle.Back)
		end
		for i, key in ipairs(keys) do
			local b = new("TextButton", {
				Position = UDim2.fromOffset(2 + (i - 1) * SUB_W, 2), Size = UDim2.fromOffset(SUB_W, 24),
				BackgroundTransparency = 1, Text = "", Font = Enum.Font.GothamBold, TextSize = 11,
				TextColor3 = (i == 1) and C.text or C.muted, AutoButtonColor = false, ZIndex = 2,
			}, subBar)
			reg(b, key)
			subBtns[i] = b
			b.MouseButton1Click:Connect(function() showSubTab(i) end)
		end
	end
	local function miscPage()
		local pgM = new("Frame", {
			Position = UDim2.fromOffset(180, 72), Size = UDim2.fromOffset(446, 310),
			BackgroundTransparency = 1, Visible = false,
		}, hub)
		pages[#pages + 1] = pgM
		reg(label(pgM, "", 20, UDim2.fromOffset(0, 0), UDim2.fromOffset(300, 28), C.text, CAT_FONT), "catMisc")
		local subPagesM = {}
		makeSubTabs(pgM, { "subSettings", "subProfils", "subTranslation" }, function(idx)
			for i, p in ipairs(subPagesM) do p.Visible = (i == idx) end
		end)
		local pSet = new("Frame", { Position = UDim2.fromOffset(0, 68), Size = UDim2.fromOffset(446, 242), BackgroundTransparency = 1, Visible = true }, pgM)
		subPagesM[1] = pSet
		local card = new("Frame", {
			Position = UDim2.fromOffset(0, 0), Size = UDim2.fromOffset(446, 64),
			BackgroundColor3 = C.panel, BorderSizePixel = 0,
		}, pSet)
		corner(card, 10)
		stroke(card, C.stroke, 1)
		Icons.key(card, 16, 23, ACCENT)
		reg(label(card, "", 14, UDim2.fromOffset(46, 12), UDim2.fromOffset(280, 20), C.text, CAT_FONT), "resetHwid")
		reg(label(card, "", 11, UDim2.fromOffset(46, 35), UDim2.fromOffset(280, 16), C.muted, Enum.Font.Gotham), "resetDesc")
		local btn = new("TextButton", {
			Position = UDim2.fromOffset(334, 17), Size = UDim2.fromOffset(100, 30), BackgroundColor3 = C.field,
			Text = S("resetBtn"), Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = C.text, AutoButtonColor = false,
		}, card)
		corner(btn, 8)
		local btnSt = stroke(btn, C.stroke, 1)
		local busy, armed = false, false
		local function idle()
			btn.Text = S("resetBtn")
			tween(btn, 0.15, { BackgroundColor3 = C.field })
			tween(btnSt, 0.15, { Color = C.stroke })
		end
		onLang[#onLang + 1] = function() if not busy and not armed then btn.Text = S("resetBtn") end end
		btn.MouseEnter:Connect(function()
			if not busy and not armed then tween(btn, 0.15, { BackgroundColor3 = Color3.fromRGB(30, 30, 34) }) end
		end)
		btn.MouseLeave:Connect(function()
			if not busy and not armed then tween(btn, 0.15, { BackgroundColor3 = C.field }) end
		end)
		btn.MouseButton1Click:Connect(function()
			if busy then return end
			if not armed then
				armed = true
				btn.Text = S("resetConfirm")
				tween(btn, 0.15, { BackgroundColor3 = Color3.fromRGB(58, 30, 30) })
				tween(btnSt, 0.15, { Color = C.err })
				task.delay(3, function()
					if armed and not busy then
						armed = false
						idle()
					end
				end)
				return
			end
			armed = false
			busy = true
			btn.Text = S("resetting")
			task.spawn(function()
				local ok = resetHwid(username)
				btn.Text = ok and S("resetOk") or S("resetFail")
				tween(btn, 0.2, { BackgroundColor3 = ok and Color3.fromRGB(28, 54, 36) or Color3.fromRGB(58, 30, 30) })
				tween(btnSt, 0.2, { Color = ok and C.good or C.err })
				task.wait(2.2)
				busy = false
				idle()
			end)
		end)
		local pProf = new("Frame", { Position = UDim2.fromOffset(0, 68), Size = UDim2.fromOffset(446, 242), BackgroundTransparency = 1, Visible = false }, pgM)
		subPagesM[2] = pProf
		local profilesHeaderLbl = label(pProf, "", 13, UDim2.fromOffset(0, 0), UDim2.fromOffset(320, 20), C.text, CAT_FONT)
		local function loadProfilesList()
			if not (isfile and isfile(Config.ProfilesFile) and readfile) then return {} end
			local ok, res = pcall(function() return HttpService:JSONDecode(readfile(Config.ProfilesFile)) end)
			if ok and type(res) == "table" then
				if res.profiles and type(res.profiles) == "table" then return res.profiles end
				local migrated = {}
				for k, v in pairs(res) do
					if tonumber(k) and type(v) == "table" then
						table.insert(migrated, { name = "Profile " .. k, data = v })
					end
				end
				return migrated
			end
			return {}
		end
		local function saveProfilesList(list)
			if not writefile then return end
			pcall(function() writefile(Config.ProfilesFile, HttpService:JSONEncode({ profiles = list })) end)
		end
		onLang[#onLang + 1] = function()
			profilesHeaderLbl.Text = string.format(S("profilesCount"), #loadProfilesList())
		end
		local profScroll = new("ScrollingFrame", {
			Position = UDim2.fromOffset(0, 30), Size = UDim2.fromOffset(446, 212),
			BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
			ScrollBarImageColor3 = Color3.fromRGB(80, 80, 88), AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromOffset(0, 0), ScrollingDirection = Enum.ScrollingDirection.Y,
		}, pProf)
		new("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6),
		}, profScroll)
		local renderProfilesList

		-- Bouton + (ajouter un profil)
		local addBtn = new("TextButton", {
			Position = UDim2.fromOffset(418, 0), Size = UDim2.fromOffset(28, 28),
			BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
		}, pProf)
		local addIconObj = Icons.plus(addBtn, C.muted, C.bg)
		addBtn.MouseEnter:Connect(function() tintIcon(addIconObj, C.text) end)
		addBtn.MouseLeave:Connect(function() tintIcon(addIconObj, C.muted) end)
		addBtn.MouseButton1Click:Connect(function()
			local list = loadProfilesList()
			if #list >= 10 then return end
			table.insert(list, { name = S("newProfileName"), data = HttpService:JSONDecode(HttpService:JSONEncode(Settings.Visuals)) })
			saveProfilesList(list)
			renderProfilesList()
			showToast(S("newProfileName"), S("toastCreated"))
		end)

		-- Bouton gomme (réinitialiser les réglages)
		local eraseBtn = new("TextButton", {
			Position = UDim2.fromOffset(384, 0), Size = UDim2.fromOffset(28, 28),
			BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
		}, pProf)
		local eraseIconObj = Icons.eraser(eraseBtn, C.muted, C.bg)
		eraseBtn.MouseEnter:Connect(function() tintIcon(eraseIconObj, C.text) end)
		eraseBtn.MouseLeave:Connect(function() tintIcon(eraseIconObj, C.muted) end)
		eraseBtn.MouseButton1Click:Connect(function()
			if loadedProfileName ~= nil then
				for k, _ in pairs(Settings.Visuals) do Settings.Visuals[k] = false end
				Settings.Visuals.snapPos = "Bottom"
				Settings.Visuals.adminAlert = false
				if refreshVisualsUI then refreshVisualsUI() end
				showToast(loadedProfileName, S("toastReset"))
				loadedProfileName = nil
			end
		end)

		renderProfilesList = function()
			for _, ch in ipairs(profScroll:GetChildren()) do
				if ch:IsA("Frame") then ch:Destroy() end
			end
			local list = loadProfilesList()
			profilesHeaderLbl.Text = string.format(S("profilesCount"), #list)
			for idx, prof in ipairs(list) do
				local row = new("Frame", {
					Size = UDim2.fromOffset(440, 40), BackgroundColor3 = C.panel, BorderSizePixel = 0, LayoutOrder = idx,
				}, profScroll)
				corner(row, 8)
				stroke(row, C.stroke, 1)
				local nameLbl = label(row, prof.name, 12, UDim2.fromOffset(12, 0), UDim2.fromOffset(210, 40), C.text, Enum.Font.GothamMedium)
				nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
				local function createActionButton(x, iconFn, hoverCol, cb)
					local b = new("TextButton", {
						Position = UDim2.fromOffset(x, 6), Size = UDim2.fromOffset(28, 28),
						BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
					}, row)
					local ico = iconFn(b, C.muted, C.panel)
					b.MouseEnter:Connect(function() tintIcon(ico, hoverCol or C.text) end)
					b.MouseLeave:Connect(function() tintIcon(ico, C.muted) end)
					b.MouseButton1Click:Connect(cb)
					return b
				end
				-- Charger
				createActionButton(246, Icons.download, C.text, function()
					pcall(function()
						if prof.data then
							for k, v in pairs(prof.data) do
								if Settings.Visuals[k] ~= nil then Settings.Visuals[k] = v end
							end
							loadedProfileName = prof.name
							if refreshVisualsUI then refreshVisualsUI() end
							showToast(prof.name, S("toastLoaded"))
						end
					end)
				end)
				-- Enregistrer
				createActionButton(278, Icons.floppy, C.text, function()
					pcall(function()
						prof.data = HttpService:JSONDecode(HttpService:JSONEncode(Settings.Visuals))
						saveProfilesList(list)
						showToast(prof.name, S("toastSaved"))
					end)
				end)
				-- Modifier (renommer)
				local renameBtn = new("TextButton", {
					Position = UDim2.fromOffset(310, 6), Size = UDim2.fromOffset(28, 28),
					BackgroundTransparency = 1, Text = "", AutoButtonColor = false,
				}, row)
				local renameIconObj = Icons.pencil(renameBtn, C.muted, C.panel)
				renameBtn.MouseEnter:Connect(function() tintIcon(renameIconObj, C.text) end)
				renameBtn.MouseLeave:Connect(function() tintIcon(renameIconObj, C.muted) end)
				local isRenaming = false
				local renameBox
				renameBtn.MouseButton1Click:Connect(function()
					pcall(function()
						if not isRenaming then
							isRenaming = true
							nameLbl.Visible = false
							for _, ch in ipairs(renameBtn:GetChildren()) do ch:Destroy() end
							renameIconObj = Icons.check(renameBtn, C.text)
							renameBox = new("TextBox", {
								Position = UDim2.fromOffset(12, 6), Size = UDim2.fromOffset(210, 28),
								BackgroundTransparency = 1, Text = prof.name, TextColor3 = C.text,
								Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
								ClearTextOnFocus = false,
							}, row)
							renameBox.FocusLost:Connect(function()
								pcall(function()
									if isRenaming then
										isRenaming = false
										local newN = renameBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
										if newN ~= "" then
											local oldN = prof.name
											prof.name = string.sub(newN, 1, 20)
											if loadedProfileName == oldN then loadedProfileName = prof.name end
											saveProfilesList(list)
										end
										renameBox:Destroy()
										nameLbl.Text = prof.name
										nameLbl.Visible = true
										for _, ch in ipairs(renameBtn:GetChildren()) do ch:Destroy() end
										renameIconObj = Icons.pencil(renameBtn, C.muted, C.panel)
										showToast(prof.name, S("toastRenamed"))
										renderProfilesList()
									end
								end)
							end)
							renameBox:CaptureFocus()
						else
							if renameBox then renameBox:CaptureFocus() end
						end
					end)
				end)
				-- Supprimer
				createActionButton(342, Icons.trash, Color3.fromRGB(255, 130, 130), function()
					pcall(function()
						if loadedProfileName == prof.name then loadedProfileName = nil end
						table.remove(list, idx)
						saveProfilesList(list)
						renderProfilesList()
						showToast(prof.name, S("toastDeleted"))
					end)
				end)
			end
		end
		renderProfilesList()
		local pTrans = new("Frame", { Position = UDim2.fromOffset(0, 68), Size = UDim2.fromOffset(446, 242), BackgroundTransparency = 1, Visible = false }, pgM)
		subPagesM[3] = pTrans
		local tCard = new("Frame", {
			Position = UDim2.fromOffset(0, 0), Size = UDim2.fromOffset(446, 64),
			BackgroundColor3 = C.panel, BorderSizePixel = 0,
		}, pTrans)
		corner(tCard, 10)
		stroke(tCard, C.stroke, 1)
		Icons.globe(tCard, 16, 23, ACCENT)
		reg(label(tCard, "", 14, UDim2.fromOffset(46, 12), UDim2.fromOffset(280, 20), C.text, CAT_FONT), "language")
		reg(label(tCard, "", 11, UDim2.fromOffset(46, 35), UDim2.fromOffset(280, 16), C.muted, Enum.Font.Gotham), "chooseLang")
		local langRefs = {}
		for idx, code in ipairs({ "FR", "EN" }) do
			local b = new("TextButton", {
				Position = UDim2.fromOffset(350 + (idx - 1) * 44, 18), Size = UDim2.fromOffset(36, 28),
				BackgroundColor3 = C.field, Text = code, Font = Enum.Font.GothamBold, TextSize = 12,
				TextColor3 = C.muted, AutoButtonColor = false,
			}, tCard)
			corner(b, 7)
			local st = stroke(b, C.stroke, 1)
			langRefs[code] = { b = b, st = st }
			b.MouseEnter:Connect(function() tween(b, 0.15, { BackgroundColor3 = Color3.fromRGB(30, 30, 34) }) end)
			b.MouseLeave:Connect(function() tween(b, 0.15, { BackgroundColor3 = C.field }) end)
			b.MouseButton1Click:Connect(function()
				currentLang = code
				saveLang()
				applyLang()
			end)
		end
		onLang[#onLang + 1] = function()
			for code, r in pairs(langRefs) do
				local on = (code == currentLang)
				r.b.TextColor3 = on and C.text or C.muted
				tween(r.st, 0.2, { Color = on and C.text or C.stroke })
			end
		end
	end
	local function visualsPage()
		local V = Settings.Visuals
		local pgF = new("Frame", {
			Position = UDim2.fromOffset(180, 72), Size = UDim2.fromOffset(446, 310),
			BackgroundTransparency = 1, Visible = false,
		}, hub)
		pages[#pages + 1] = pgF
		reg(label(pgF, "", 20, UDim2.fromOffset(0, 0), UDim2.fromOffset(300, 28), C.text, CAT_FONT), "catVisuals")
		local subPagesV = {}
		makeSubTabs(pgF, { "subGeneral", "subAdvanced" }, function(idx)
			for i, p in ipairs(subPagesV) do p.Visible = (i == idx) end
		end)
		local pgGeneral = new("Frame", {
			Position = UDim2.fromOffset(0, 68), Size = UDim2.fromOffset(446, 242), BackgroundTransparency = 1, Visible = true,
		}, pgF)
		subPagesV[1] = pgGeneral
		local function card(parent, x, w, h)
			local f = new("Frame", {
				Position = UDim2.fromOffset(x, 0), Size = UDim2.fromOffset(w, h),
				BackgroundColor3 = C.panel, BorderSizePixel = 0, ClipsDescendants = true,
			}, parent)
			corner(f, 10)
			stroke(f, C.stroke, 1)
			return f
		end
		local setCard = card(pgGeneral, 0, 226, 242)
		local preCard = card(pgGeneral, 238, 208, 242)
		reg(label(setCard, "", 13, UDim2.fromOffset(14, 8), UDim2.fromOffset(160, 20), C.text, CAT_FONT), "settingsTitle")
		Icons.previewSymbol(preCard, 14, 11, ACCENT)
		reg(label(preCard, "", 13, UDim2.fromOffset(36, 8), UDim2.fromOffset(170, 20), C.text, CAT_FONT), "previewTitle")
		local opts = {
			{ "enable", "optEnable" }, { "boxes", "optBoxes" }, { "snaplines", "optSnaplines" },
			{ "skeleton", "optSkeleton" }, { "names", "optNames" }, { "distance", "optDistance" }, { "health", "optHealth" },
			{ "armor", "optArmor" }, { "weapon", "optWeapon" }, { "count", "optCount" },
		}
		local ROW_H = 32
		local scroll = new("ScrollingFrame", {
			Position = UDim2.fromOffset(0, 34), Size = UDim2.fromOffset(226, 202),
			BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2,
			ScrollBarImageColor3 = Color3.fromRGB(80, 80, 88), AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.fromOffset(0, 0), ScrollingDirection = Enum.ScrollingDirection.Y,
		}, setCard)
		local BW, BH = 208, 208
		local body = new("Frame", {
			Position = UDim2.fromOffset(0, 30), Size = UDim2.fromOffset(BW, BH),
			BackgroundTransparency = 1, ClipsDescendants = true,
		}, preCard)
		local vp = new("ViewportFrame", {
			Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
			Ambient = Color3.fromRGB(200, 200, 205), LightColor = Color3.fromRGB(255, 255, 255),
			LightDirection = Vector3.new(0.3, -0.5, -1),
		}, body)
		local function projectVF(cam, worldPos, W, H)
			local lp = cam.CFrame:PointToObjectSpace(worldPos)
			if lp.Z >= 0 then return 0, 0, false end
			local t = math.tan(math.rad(cam.FieldOfView / 2))
			local x = W / 2 + (lp.X / (-lp.Z * t)) * (H / 2)
			local y = H / 2 - (lp.Y / (-lp.Z * t)) * (H / 2)
			return x, y, true
		end
		local function buildModel()
			local model
			pcall(function()
				local desc = Players:GetHumanoidDescriptionFromUserId(player.UserId)
				if desc then
					model = Players:CreateHumanoidModelFromDescription(desc, Enum.HumanoidRigType.R15)
				end
			end)
			if not model and player.Character then
				pcall(function()
					player.Character.Archivable = true
					model = player.Character:Clone()
					player.Character.Archivable = false
				end)
			end
			if model then
				for _, child in ipairs(model:GetChildren()) do
					if child:IsA("Script") or child:IsA("LocalScript") or child:IsA("Sound") or child:IsA("ForceField") or child:IsA("Tool") or child:IsA("BillboardGui") then
						child:Destroy()
					elseif child:IsA("Humanoid") then
						child.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
						child.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
					end
				end
				local rootPart = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("UpperTorso") or model:FindFirstChild("Torso")
				if rootPart then
					local visited = {}
					local queue = { rootPart }
					visited[rootPart] = true
					while #queue > 0 do
						local current = table.remove(queue, 1)
						for _, desc in ipairs(model:GetDescendants()) do
							if (desc:IsA("Motor6D") or desc:IsA("Weld") or desc:IsA("WeldConstraint")) and desc.Part0 == current and desc.Part1 and not visited[desc.Part1] then
								local p0, p1 = desc.Part0, desc.Part1
								if desc:IsA("Motor6D") then
									desc.Transform = CFrame.new()
									p1.CFrame = p0.CFrame * desc.C0 * desc.C1:Inverse()
								elseif desc:IsA("Weld") then
									p1.CFrame = p0.CFrame * desc.C0 * desc.C1:Inverse()
								end
								visited[p1] = true
								table.insert(queue, p1)
							end
						end
					end
				end
				for _, acc in ipairs(model:GetChildren()) do
					if acc:IsA("Accessory") then
						local handle = acc:FindFirstChild("Handle")
						if handle then
							local attHandle = handle:FindFirstChildOfClass("Attachment")
							local head = model:FindFirstChild("Head")
							if attHandle and head then
								local attPerso = head:FindFirstChild(attHandle.Name) or model:FindFirstChild(attHandle.Name, true)
								if attPerso and attPerso:IsA("Attachment") then
									handle.CFrame = attPerso.Parent.CFrame * attPerso.CFrame * attHandle.CFrame:Inverse()
								end
							end
							if head and (handle.Position - head.Position).Magnitude > 6 then
								handle:Destroy()
							end
						end
					end
				end
				for _, d in ipairs(model:GetDescendants()) do
					if d:IsA("AnimationTrack") or d.Name == "Animate" then d:Destroy() end
				end
			end
			if not model then
				model = Instance.new("Model")
				local function part(name, size, pos, col)
					local p = Instance.new("Part")
					p.Name = name; p.Size = size; p.Position = pos; p.Color = col
					p.Material = Enum.Material.SmoothPlastic
					p.Parent = model
				end
				local skin = Color3.fromRGB(245, 205, 150)
				part("Head", Vector3.new(1.2, 1.2, 1.2), Vector3.new(0, 4.9, 0), skin)
				part("UpperTorso", Vector3.new(2, 1.5, 1), Vector3.new(0, 3.5, 0), Color3.fromRGB(35, 35, 42))
				part("LowerTorso", Vector3.new(2, 0.8, 1), Vector3.new(0, 2.5, 0), Color3.fromRGB(45, 50, 75))
			end
			local primary = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart") or model:FindFirstChild("UpperTorso") or model:FindFirstChild("Torso")
			if primary then model.PrimaryPart = primary end
			for _, d in ipairs(model:GetDescendants()) do
				if d:IsA("BasePart") then d.Anchored = true; d.CanCollide = false end
			end
			return model
		end
		local model = buildModel()
		model.Parent = vp
		model:PivotTo(CFrame.new(0, 0, 0))
		local cf, size = model:GetBoundingBox()
		local maxDim = math.max(size.X, size.Y, size.Z, 3)
		local dist = maxDim / (0.66 * 2 * math.tan(math.rad(20)))
		local cam = Instance.new("Camera")
		cam.FieldOfView = 40
		cam.CFrame = CFrame.lookAt(cf.Position + Vector3.new(0, 0, -dist), cf.Position)
		cam.Parent = vp
		vp.CurrentCamera = cam
		local function place(a)
			model:PivotTo(CFrame.new(cf.Position) * CFrame.Angles(0, a, 0))
		end
		place(0)
		local BOXH = BH * 0.66
		local BOXW = BOXH * 0.6
		local CXb, CYb = BW / 2, BH / 2
		local bx0, by0 = CXb - BOXW / 2, CYb - BOXH / 2
		local bx1, by1 = bx0 + BOXW, by0 + BOXH
		local function group()
			return new("CanvasGroup", {
				Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, GroupTransparency = 1,
			}, body)
		end
		local gSnap, gSkel, gBox, gName, gHealth, gArmor, gWeapon, gCount, gDist =
			group(), group(), group(), group(), group(), group(), group(), group(), group()
		local snapCol = Color3.fromRGB(235, 239, 247)
		local snapItems = { Bottom = {}, Top = {} }
		snapItems.Bottom[1] = mkLine(gSnap, snapCol)
		setLine(snapItems.Bottom[1], BW / 2, BH, CXb, by1, 1.5)
		snapItems.Bottom[2] = fillDot(gSnap, CXb - 2.5, by1 - 2.5, 5, snapCol)
		snapItems.Top[1] = mkLine(gSnap, snapCol)
		setLine(snapItems.Top[1], BW / 2, 0, CXb, by0, 1.5)
		snapItems.Top[2] = fillDot(gSnap, CXb - 2.5, by0 - 2.5, 5, snapCol)
		local distLbl = new("TextLabel", {
			BackgroundTransparency = 1, Position = UDim2.fromOffset(CXb - 70, by1 + 6), Size = UDim2.fromOffset(140, 14),
			Text = "24m", Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = Color3.fromRGB(200, 205, 215),
			TextStrokeTransparency = 0.55, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 3,
		}, gDist)
		local distBgPrev = new("Frame", {
			BackgroundColor3 = Color3.fromRGB(15, 15, 18), BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 2,
		}, gDist)
		corner(distBgPrev, 3)
		local skelCol = Color3.fromRGB(150, 215, 255)
		local previewBones, previewBoneShadows = {}, {}
		for i = 1, 24 do
			local b, sh = mkBone(gSkel, skelCol)
			previewBones[i] = b
			previewBoneShadows[i] = sh
		end
		local previewJoints = {}
		for _, jn in ipairs(JOINT_NAMES) do
			local jsz = (jn == "Head") and 7 or 4
			previewJoints[jn] = mkJoint(gSkel, skelCol, jsz)
		end
		local boxF = new("Frame", {
			Position = UDim2.fromOffset(bx0, by0), Size = UDim2.fromOffset(BOXW, BOXH), BackgroundTransparency = 1,
		}, gBox)
		stroke(boxF, Color3.new(1, 1, 1), 1.5)
		new("TextLabel", {
			BackgroundTransparency = 1, Position = UDim2.fromOffset(CXb - 70, by0 - 17), Size = UDim2.fromOffset(140, 14),
			Text = player.DisplayName, Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = C.text,
			TextStrokeTransparency = 0.55, TextXAlignment = Enum.TextXAlignment.Center,
		}, gName)
		local hBar = new("Frame", {
			Position = UDim2.fromOffset(bx0 - 7, by0), Size = UDim2.fromOffset(4, BOXH),
			BackgroundColor3 = Color3.fromRGB(30, 30, 34), BorderSizePixel = 0,
		}, gHealth)
		local hClip = new("Frame", {
			AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1, ClipsDescendants = true,
		}, hBar)
		local hFill = new("Frame", {
			AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.fromOffset(4, BOXH),
			BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0,
		}, hClip)
		new("UIGradient", {
			Rotation = 90,
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 230, 110)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(240, 210, 70)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(240, 70, 70)),
			}),
		}, hFill)
		local hNum = new("TextLabel", {
			AnchorPoint = Vector2.new(1, 0.5), Size = UDim2.fromOffset(26, 12), BackgroundTransparency = 1, Text = "100",
			Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Color3.fromRGB(110, 231, 140), TextXAlignment = Enum.TextXAlignment.Right,
			TextStrokeTransparency = 0.5,
		}, gHealth)
		local aBar = new("Frame", {
			Position = UDim2.fromOffset(bx0 - 13, by0), Size = UDim2.fromOffset(4, BOXH),
			BackgroundColor3 = Color3.fromRGB(30, 30, 34), BorderSizePixel = 0,
		}, gArmor)
		local aClip = new("Frame", {
			AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1, ClipsDescendants = true,
		}, aBar)
		local aFill = new("Frame", {
			AnchorPoint = Vector2.new(0, 1), Position = UDim2.fromScale(0, 1), Size = UDim2.fromOffset(4, BOXH),
			BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0,
		}, aClip)
		new("UIGradient", {
			Rotation = 90,
			Color = ColorSequence.new(Color3.fromRGB(120, 190, 255), Color3.fromRGB(60, 100, 230)),
		}, aFill)
		local aNum = new("TextLabel", {
			AnchorPoint = Vector2.new(1, 0.5), Size = UDim2.fromOffset(26, 12), BackgroundTransparency = 1, Text = "75",
			Font = Enum.Font.GothamBold, TextSize = 10, TextColor3 = Color3.fromRGB(130, 190, 255), TextXAlignment = Enum.TextXAlignment.Right,
			TextStrokeTransparency = 0.5,
		}, gArmor)
		local weaponLbl = new("TextLabel", {
			BackgroundTransparency = 1, Position = UDim2.fromOffset(CXb - 70, by1 + 6), Size = UDim2.fromOffset(140, 14),
			Text = "AK-47", Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = Color3.fromRGB(235, 215, 160),
			TextStrokeTransparency = 0.55, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 3,
		}, gWeapon)
		local weapBgPrev = new("Frame", {
			BackgroundColor3 = Color3.fromRGB(15, 15, 18), BackgroundTransparency = 0.35, BorderSizePixel = 0, ZIndex = 2,
		}, gWeapon)
		corner(weapBgPrev, 3)
		local countBox = new("Frame", {
			Position = UDim2.new(0, 8, 1, -30), Size = UDim2.fromOffset(90, 22),
			BackgroundColor3 = C.bg, BackgroundTransparency = 0.15, BorderSizePixel = 0,
		}, gCount)
		corner(countBox, 6)
		stroke(countBox, C.stroke, 1)
		local countLbl = new("TextLabel", {
			BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Font = Enum.Font.GothamMedium,
			TextSize = 11, TextColor3 = C.text, Text = "", TextXAlignment = Enum.TextXAlignment.Center,
		}, countBox)
		local function updateCount()
			countLbl.Text = S("playersLbl") .. ": " .. #Players:GetPlayers()
		end
		updateCount()
		onLang[#onLang + 1] = updateCount
		local groups = {
			boxes = gBox, snaplines = gSnap, skeleton = gSkel, names = gName, distance = gDist,
			health = gHealth, armor = gArmor, weapon = gWeapon, count = gCount,
		}
		local rows = {}
		local render
		render = function()
			for pos, items in pairs(snapItems) do
				for _, it in ipairs(items) do it.Visible = (V.snapPos == pos) end
			end
			for k, g in pairs(groups) do
				local on = V.enable and V[k]
				tween(g, 0.2, { GroupTransparency = on and 0 or 1 })
			end
			for k, r in pairs(rows) do
				r.set(V[k])
				if k ~= "enable" then
					tween(r.lbl, 0.15, { TextColor3 = V.enable and C.text or C.muted })
				end
			end
		end
		refreshVisualsUI = function()
			render()
			if refreshDD then refreshDD() end
			if refreshAdminUI then refreshAdminUI() end
		end
		local BOX_OFF = Color3.fromRGB(20, 20, 24)
		local BOX_OFF_STROKE = Color3.fromRGB(34, 34, 40)
		for idx, o in ipairs(opts) do
			local k, tk = o[1], o[2]
			local row = new("Frame", {
				Position = UDim2.fromOffset(0, (idx - 1) * ROW_H + 2), Size = UDim2.fromOffset(226, ROW_H), BackgroundTransparency = 1,
			}, scroll)
			local cbox = new("Frame", {
				AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 14, 0.5, 0),
				Size = UDim2.fromOffset(22, 22), BackgroundColor3 = BOX_OFF, BorderSizePixel = 0,
			}, row)
			corner(cbox, 6)
			local cboxSt = stroke(cbox, BOX_OFF_STROKE, 1)
			local mark = new("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromOffset(18, 18), BackgroundTransparency = 1,
			}, cbox)
			Icons.check(mark, Color3.new(0, 0, 0))
			local markScale = new("UIScale", { Scale = 0 }, mark)
			if k == "snaplines" then
				row.ZIndex = 20
				local ddBtn = new("TextButton", {
					AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
					Size = UDim2.fromOffset(56, 22), BackgroundColor3 = C.field, Text = "",
					AutoButtonColor = false, ZIndex = 8,
				}, row)
				corner(ddBtn, 6)
				local ddSt = stroke(ddBtn, C.stroke, 1)
				local ddLbl = label(ddBtn, "", 10, UDim2.fromOffset(8, 0), UDim2.fromOffset(36, 22), C.text, Enum.Font.GothamMedium)
				ddLbl.ZIndex = 9
				for _, rot in ipairs({ 40, -40 }) do
					cornerS(new("Frame", {
						AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(rot > 0 and 44.2 or 47.8, 11.5),
						Size = UDim2.fromOffset(5, 1.6), Rotation = rot, BackgroundColor3 = C.muted,
						BorderSizePixel = 0, ZIndex = 9,
					}, ddBtn), 0.5)
				end
				local ddList = new("Frame", {
					Position = UDim2.fromOffset(226 - 10 - 56, ROW_H / 2 + 14), Size = UDim2.fromOffset(56, 50),
					BackgroundColor3 = Color3.fromRGB(24, 24, 28), BorderSizePixel = 0, Visible = false, ZIndex = 15,
				}, row)
				corner(ddList, 6)
				stroke(ddList, Color3.fromRGB(60, 60, 68), 1)
				local ddOpts = {}
				for n, pos in ipairs({ "Top", "Bottom" }) do
					local ob = new("TextButton", {
						Position = UDim2.fromOffset(2, 2 + (n - 1) * 23), Size = UDim2.fromOffset(52, 22),
						BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 1, Text = "",
						AutoButtonColor = false, ZIndex = 16,
					}, ddList)
					corner(ob, 5)
					local ol = label(ob, "", 10, UDim2.fromOffset(8, 0), UDim2.fromOffset(40, 22), C.text, Enum.Font.GothamMedium)
					ol.ZIndex = 17
					ddOpts[pos] = { ob = ob, ol = ol }
					ob.MouseEnter:Connect(function() ob.BackgroundTransparency = 0.88 end)
					ob.MouseLeave:Connect(function() ob.BackgroundTransparency = 1 end)
					ob.MouseButton1Click:Connect(function()
						V.snapPos = pos
						ddList.Visible = false
						refreshDD()
						render()
					end)
				end
				refreshDD = function()
					ddLbl.Text = S(V.snapPos == "Top" and "snapTop" or "snapBottom")
					for pos, o in pairs(ddOpts) do
						o.ol.Text = S(pos == "Top" and "snapTop" or "snapBottom")
						o.ol.TextColor3 = (V.snapPos == pos) and C.text or C.muted
					end
				end
				refreshDD()
				onLang[#onLang + 1] = refreshDD
				ddBtn.MouseEnter:Connect(function() tween(ddSt, 0.15, { Color = Color3.fromRGB(90, 90, 100) }) end)
				ddBtn.MouseLeave:Connect(function() tween(ddSt, 0.15, { Color = C.stroke }) end)
				ddBtn.MouseButton1Click:Connect(function() ddList.Visible = not ddList.Visible end)
			end
			local lbl = reg(label(row, "", 12, UDim2.fromOffset(46, 0), UDim2.fromOffset((k == "snaplines") and 108 or 172, ROW_H), C.text, Enum.Font.GothamMedium), tk)
			lbl.TextTruncate = Enum.TextTruncate.AtEnd
			local btn = new("TextButton", {
				Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5,
			}, row)
			btn.MouseEnter:Connect(function()
				if not V[k] then tween(cboxSt, 0.15, { Color = Color3.fromRGB(80, 80, 92) }) end
			end)
			btn.MouseLeave:Connect(function()
				if not V[k] then tween(cboxSt, 0.15, { Color = BOX_OFF_STROKE }) end
			end)
			rows[k] = {
				lbl = lbl,
				set = function(on)
					tween(cbox, 0.18, { BackgroundColor3 = on and ACCENT or BOX_OFF })
					tween(cboxSt, 0.18, { Color = on and ACCENT or BOX_OFF_STROKE })
					tween(markScale, 0.22, { Scale = on and 1 or 0 }, on and Enum.EasingStyle.Back or Enum.EasingStyle.Quad)
				end,
			}
			btn.MouseButton1Click:Connect(function()
				V[k] = not V[k]
				render()
			end)
		end
		render()
		local pgAdvanced = new("Frame", {
			Position = UDim2.fromOffset(0, 68), Size = UDim2.fromOffset(446, 242), BackgroundTransparency = 1, Visible = false,
		}, pgF)
		subPagesV[2] = pgAdvanced
		local advCard = new("Frame", {
			Position = UDim2.fromOffset(0, 0), Size = UDim2.fromOffset(446, 64),
			BackgroundColor3 = C.panel, BorderSizePixel = 0,
		}, pgAdvanced)
		corner(advCard, 10)
		stroke(advCard, C.stroke, 1)
		reg(label(advCard, "", 13, UDim2.fromOffset(48, 12), UDim2.fromOffset(380, 20), C.text, Enum.Font.GothamBold), "adminAlertTitle")
		reg(label(advCard, "", 11, UDim2.fromOffset(48, 34), UDim2.fromOffset(380, 16), C.muted, Enum.Font.Gotham), "adminAlertDesc")
		local advCbox = new("Frame", {
			AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 14, 0.5, 0),
			Size = UDim2.fromOffset(22, 22), BackgroundColor3 = V.adminAlert and ACCENT or BOX_OFF, BorderSizePixel = 0,
		}, advCard)
		corner(advCbox, 6)
		local advCboxSt = stroke(advCbox, V.adminAlert and ACCENT or BOX_OFF_STROKE, 1)
		local advMark = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(18, 18), BackgroundTransparency = 1,
		}, advCbox)
		Icons.check(advMark, Color3.new(0, 0, 0))
		local advMarkScale = new("UIScale", { Scale = V.adminAlert and 1 or 0 }, advMark)
		refreshAdminUI = function()
			local on = V.adminAlert
			tween(advCbox, 0.18, { BackgroundColor3 = on and ACCENT or BOX_OFF })
			tween(advCboxSt, 0.18, { Color = on and ACCENT or BOX_OFF_STROKE })
			tween(advMarkScale, 0.22, { Scale = on and 1 or 0 }, on and Enum.EasingStyle.Back or Enum.EasingStyle.Quad)
		end
		local advBtn = new("TextButton", {
			Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 5,
		}, advCard)
		advBtn.MouseEnter:Connect(function()
			if not V.adminAlert then tween(advCboxSt, 0.15, { Color = Color3.fromRGB(80, 80, 92) }) end
		end)
		advBtn.MouseLeave:Connect(function()
			if not V.adminAlert then tween(advCboxSt, 0.15, { Color = BOX_OFF_STROKE }) end
		end)
		advBtn.MouseButton1Click:Connect(function()
			V.adminAlert = not V.adminAlert
			refreshAdminUI()
		end)
		local t0, lastCount = os.clock(), 0
		local previewSmoothedJoints = {}
		local conn
		conn = RunService.RenderStepped:Connect(function()
			if not alive(hub) then conn:Disconnect() return end
			if not (pgF.Visible and hub.Visible) then return end
			local t = os.clock() - t0
			place(math.sin(t * 0.9) * 0.45)
			local currentDist = math.floor(24 + 9 * math.sin(t * 0.7))
			distLbl.Text = currentDist .. "m"
			distBgPrev.Position = UDim2.fromOffset(CXb - 22, by1 + 6)
			distBgPrev.Size = UDim2.fromOffset(44, 14)
			local currentWeapY = by1 + 6 + (V.distance and 16 or 0)
			weaponLbl.Position = UDim2.fromOffset(CXb - 70, currentWeapY)
			weapBgPrev.Position = UDim2.fromOffset(CXb - 35, currentWeapY)
			weapBgPrev.Size = UDim2.fromOffset(70, 14)
			local hp = 78 + 22 * math.sin(t * 0.8)
			local pct = hp / 100
			hClip.Size = UDim2.fromScale(1, pct)
			hNum.Text = tostring(math.floor(hp + 0.5))
			local numY = math.clamp(by0 + BOXH * (1 - pct), by0, by1 - 4)
			local ap = 0.72 + 0.2 * math.sin(t * 0.6 + 1.2)
			aClip.Size = UDim2.fromScale(1, ap)
			aNum.Text = tostring(math.floor(ap * 100 + 0.5))
			local anumY = math.clamp(by0 + BOXH * (1 - ap), by0, by1 - 4)
			if math.abs(anumY - numY) < 11 then
				anumY = math.clamp(numY + 11, by0, by1 + 6)
			end
			hNum.Position = UDim2.fromOffset(bx0 - 16, numY)
			aNum.Position = UDim2.fromOffset(bx0 - 16, anumY)
			local pts = getSkeletonPoints(model)
			local shownP = {}
			for name, pos in pairs(pts) do
				local px, py, ok = projectVF(cam, pos, BW, BH)
				if ok then
					local targetV2 = Vector2.new(px, py)
					local currentV2 = previewSmoothedJoints[name]
					if not currentV2 then
						currentV2 = targetV2
					else
						currentV2 = currentV2:Lerp(targetV2, 0.5)
					end
					previewSmoothedJoints[name] = currentV2
					shownP[name] = { pos = currentV2, visible = true }
				else
					previewSmoothedJoints[name] = nil
				end
			end
			for i = 1, #previewBones do
				local ln = previewBones[i]
				local sh = previewBoneShadows[i]
				local boneData = SKELETON_BONES[i]
				if boneData then
					local j1 = shownP[boneData[1]]
					local j2 = shownP[boneData[2]]
					if j1 and j2 then
						setBoneLine(ln, sh, j1.pos.X, j1.pos.Y, j2.pos.X, j2.pos.Y, 2.2)
					else
						ln.Visible = false
						if sh then sh.Visible = false end
					end
				else
					ln.Visible = false
					if sh then sh.Visible = false end
				end
			end
			for name, jf in pairs(previewJoints) do
				local jInfo = shownP[name]
				if jInfo then
					jf.Position = UDim2.fromOffset(jInfo.pos.X, jInfo.pos.Y)
					jf.Visible = true
				else
					jf.Visible = false
				end
			end
			if t - lastCount > 1 then
				lastCount = t
				updateCount()
			end
		end)
	end
	visualsPage()
	comingSoon("catAssist")
	comingSoon("catPlayer")
	comingSoon("catFarm")
	miscPage()
	comingSoon("catCustom")
	local current
	local tabBtns, tabPads, tabIcons, tabScales = {}, {}, {}, {}
	local function showTab(k)
		if current == k then return end
		local dir = (current and k < current) and -1 or 1
		for i, pgT in ipairs(pages) do
			if i == k then
				local isCG = pgT:IsA("CanvasGroup")
				pgT.Visible = true
				if isCG then pgT.GroupTransparency = 1 end
				pgT.Position = UDim2.fromOffset(180, 72 + 16 * dir)
				tween(pgT, 0.4, isCG and { GroupTransparency = 0, Position = UDim2.fromOffset(180, 72) } or { Position = UDim2.fromOffset(180, 72) }, Enum.EasingStyle.Quint)
			else
				pgT.Visible = false
			end
		end
		tween(pill, 0.35, { Position = UDim2.fromOffset(0, (k - 1) * 36) }, Enum.EasingStyle.Back)
		for j, b in ipairs(tabBtns) do
			local sel = (j == k)
			tween(b, 0.2, { TextColor3 = sel and C.text or TXT_OFF })
			tween(tabPads[j], 0.35, { PaddingLeft = UDim.new(0, sel and 46 or 16) }, Enum.EasingStyle.Back)
			if sel then
				tabIcons[j].Rotation = -70
				tabScales[j].Scale = 0
				tween(tabScales[j], 0.45, { Scale = 1 }, Enum.EasingStyle.Back)
				tween(tabIcons[j], 0.45, { Rotation = 0 }, Enum.EasingStyle.Back)
			elseif tabScales[j].Scale > 0 then
				tween(tabScales[j], 0.2, { Scale = 0 })
			end
		end
		current = k
	end
	for i, cat in ipairs(cats) do
		local rowY = (i - 1) * 36
		local ico = cat.icon(side, 0, 0, ACCENT, C.tabSel)
		ico.AnchorPoint = Vector2.new(0.5, 0.5)
		ico.Position = UDim2.fromOffset(25, rowY + 18)
		ico.ZIndex = 3
		for _, d in ipairs(ico:GetDescendants()) do
			if d:IsA("GuiObject") then d.ZIndex = 3 end
		end
		tabScales[i] = new("UIScale", { Scale = 0 }, ico)
		tabIcons[i] = ico
		local b = new("TextButton", {
			Position = UDim2.fromOffset(-24, rowY), Size = UDim2.fromOffset(150, 36), BackgroundTransparency = 1,
			Text = "", Font = CAT_FONT, TextSize = 14, TextColor3 = TXT_OFF,
			TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false, ZIndex = 2,
			TextTransparency = 1,
		}, side)
		reg(b, cat.key)
		tabPads[i] = new("UIPadding", { PaddingLeft = UDim.new(0, 16) }, b)
		tabBtns[i] = b
		task.delay(0.35 + i * 0.07, function()
			tween(b, 0.5, { Position = UDim2.fromOffset(0, rowY), TextTransparency = 0 }, Enum.EasingStyle.Back)
		end)
		b.MouseEnter:Connect(function()
			if current ~= i then
				tween(b, 0.15, { TextColor3 = TXT_HOVER })
				tween(tabPads[i], 0.2, { PaddingLeft = UDim.new(0, 22) })
			end
		end)
		b.MouseLeave:Connect(function()
			if current ~= i then
				tween(b, 0.15, { TextColor3 = TXT_OFF })
				tween(tabPads[i], 0.2, { PaddingLeft = UDim.new(0, 16) })
			end
		end)
		b.MouseButton1Click:Connect(function() showTab(i) end)
	end
	local rankText = tostring(rank or "Standard")
	rankText = string.upper(string.sub(rankText, 1, 1)) .. string.sub(rankText, 2)
	local rk = string.lower(rankText)
	local theme = rankTheme(rk)
	local nameLbl = new("TextLabel", {
		BackgroundTransparency = 1, Position = UDim2.fromOffset(16, 322), Size = UDim2.fromOffset(148, 20),
		Text = username, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = C.text,
		TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, TextTransparency = 1,
	}, hub)

	local rankLbl = new("TextLabel", {
		BackgroundTransparency = 1, Position = UDim2.fromOffset(16, 344), Size = UDim2.fromOffset(0, 20),
		AutomaticSize = Enum.AutomaticSize.X, Text = rankText, Font = Enum.Font.GothamBlack, TextSize = 14,
		TextColor3 = Color3.new(1, 1, 1), TextXAlignment = Enum.TextXAlignment.Left, TextTransparency = 1,
	}, hub)
	applyRankShine(rankLbl, theme)

	local exp = makeExpiry(hub, UDim2.fromOffset(16, 368), 148, 16, 11)
	exp.root.Visible = false

	for n, lbl in ipairs({ nameLbl, rankLbl }) do
		local final = lbl.Position
		lbl.Position = UDim2.new(final.X.Scale, final.X.Offset - 14, final.Y.Scale, final.Y.Offset)
		task.delay(0.75 + n * 0.12, function()
			tween(lbl, 0.55, { Position = final, TextTransparency = 0 }, Enum.EasingStyle.Back)
		end)
	end
	task.delay(1.2, function()
		if alive(exp.root) then
			exp.root.Position = UDim2.fromOffset(2, 368)
			exp.root.Visible = true
			tween(exp.root, 0.55, { Position = UDim2.fromOffset(16, 368) }, Enum.EasingStyle.Back)
		end
	end)

	applyLang = function()
		for _, r in ipairs(trList) do r.lbl.Text = S(r.key) end
		for _, f in ipairs(onLang) do f() end
		local life = isLifetimeVal(expires)
		local prefixKey = (not life) and "expiresOn" or "expiresAt"
		exp.set(S(prefixKey), expires)
	end
	applyLang()
	local hubOpen = true
	local kWrap = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 64, 0.5, -40),
		Size = UDim2.fromOffset(64, 64), BackgroundTransparency = 1, ZIndex = 80,
	}, gui)
	local kScale = new("UIScale", { Scale = 0 }, kWrap)
	local kFloat = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 81 }, kWrap)
	if IconAssets.k then
		new("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 3), Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1, Image = IconAssets.k, ImageColor3 = Color3.new(0, 0, 0),
			ImageTransparency = 0.55, ScaleType = Enum.ScaleType.Fit, ZIndex = 80,
		}, kFloat)
		new("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1, Image = IconAssets.k, ScaleType = Enum.ScaleType.Fit, ZIndex = 82,
		}, kFloat)
	else
		new("TextLabel", {
			BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = "K", Font = Enum.Font.GothamBlack,
			TextScaled = true, TextColor3 = Color3.fromRGB(230, 230, 236), ZIndex = 82,
		}, kFloat)
	end
	local kBtn = new("TextButton", {
		Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 90,
	}, kWrap)
	task.spawn(function()
		local t = 0
		while alive(kWrap) do
			t += task.wait()
			kFloat.Position = UDim2.fromOffset(0, math.sin(t * 2) * 3)
			kFloat.Rotation = math.sin(t * 1.3) * 3
		end
	end)
	setHub = function(open)
		if open == hubOpen then return end
		hubOpen = open
		kScale.Scale = 0.8
		tween(kScale, 0.4, { Scale = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		if open then
			hub.Visible = true
			hub.Size = UDim2.fromOffset(0, 0)
			tween(hub, 0.55, { Size = UDim2.fromOffset(640, 400) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		else
			tween(hub, 0.35, { Size = UDim2.fromOffset(0, 0) }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
			task.delay(0.38, function()
				if not hubOpen then hub.Visible = false end
			end)
		end
	end
	kBtn.MouseEnter:Connect(function() tween(kScale, 0.2, { Scale = 1.12 }, Enum.EasingStyle.Back) end)
	kBtn.MouseLeave:Connect(function() tween(kScale, 0.2, { Scale = 1 }, Enum.EasingStyle.Back) end)
	do
		local dragging, moved, startMouse, startPos = false, false, nil, nil
		kBtn.InputBegan:Connect(function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging, moved, startMouse, startPos = true, false, i.Position, kWrap.Position
				tween(kScale, 0.1, { Scale = 0.9 })
			end
		end)
		UserInputService.InputChanged:Connect(function(i)
			if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
				local d = i.Position - startMouse
				if d.Magnitude > 6 then moved = true end
				if moved then
					kWrap.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
				end
			end
		end)
		UserInputService.InputEnded:Connect(function(i)
			if dragging and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
				dragging = false
				tween(kScale, 0.2, { Scale = 1 }, Enum.EasingStyle.Back)
				if not moved then setHub(not hubOpen) end
			end
		end)
	end
	task.delay(0.9, function()
		tween(kScale, 0.7, { Scale = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	end)
	showTab(1)
	tween(hub, 0.6, { Size = UDim2.fromOffset(640, 400) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

---------------------------------------------------------------------
-- ÉCRAN DE CHARGEMENT
---------------------------------------------------------------------
local function openMainDashboard(username, rank, expires, expiresAt)
	if gui:FindFirstChild("KryptonDashboard") then return end
	local W, H = 560, 392
	local CX, CY = W / 2, 130
	local mainWin = new("Frame", {
		Name = "KryptonDashboard",
		Size = UDim2.fromOffset(0, 0), AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundColor3 = C.bg,
		BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 50,
	}, gui)
	corner(mainWin, 14)
	stroke(mainWin, C.stroke, 1, 0.3)
	local sc = new("UIScale", {}, mainWin)
	local function us()
		local v = gui.AbsoluteSize
		sc.Scale = math.clamp(math.min(v.X / 640, v.Y / 520), 0.4, 1)
	end
	us()
	gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(us)
	makeParticles(mainWin, W, H, 12)
	local topDrag = new("Frame", { Size = UDim2.fromOffset(W, 56), BackgroundTransparency = 1 }, mainWin)
	makeDraggable(mainWin, topDrag)
	local rankText = tostring(rank or "Standard")
	rankText = string.upper(string.sub(rankText, 1, 1)) .. string.sub(rankText, 2)
	local rk = string.lower(rankText)
	local rankCol = Color3.fromRGB(255, 226, 110)
	if rk == "free" then rankCol = Color3.fromRGB(135, 210, 255)
	elseif rk == "standard" then rankCol = Color3.fromRGB(140, 240, 165) end
	local card = new("Frame", {
		Position = UDim2.fromOffset(16, -110), Size = UDim2.fromOffset(200, 96),
		BackgroundColor3 = C.panel, BorderSizePixel = 0, ZIndex = 3,
	}, mainWin)
	corner(card, 10)
	stroke(card, C.stroke, 1)
	label(card, S("license"), 10, UDim2.fromOffset(14, 9), UDim2.fromOffset(80, 14), C.muted, Enum.Font.Gotham)
	applyRankShine(label(card, rankText, 14, UDim2.fromOffset(14, 23), UDim2.fromOffset(80, 20), rankCol, Enum.Font.GothamBlack), rankTheme(rk))
	label(card, S("expires"), 10, UDim2.fromOffset(104, 9), UDim2.fromOffset(84, 14), C.muted, Enum.Font.Gotham)
	makeExpiry(card, UDim2.fromOffset(104, 23), 84, 20, 13).set("", expires)
	new("Frame", { Position = UDim2.fromOffset(14, 49), Size = UDim2.fromOffset(172, 1), BackgroundColor3 = C.stroke, BorderSizePixel = 0 }, card)
	local gDot = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(18, 71),
		Size = UDim2.fromOffset(8, 8), BackgroundColor3 = C.muted, BorderSizePixel = 0,
	}, card)
	new("UICorner", { CornerRadius = UDim.new(0.5, 0) }, gDot)
	local gLbl = label(card, "...", 12, UDim2.fromOffset(30, 62), UDim2.fromOffset(160, 18), C.text, Enum.Font.GothamMedium)
	gLbl.TextTruncate = Enum.TextTruncate.AtEnd
	task.spawn(function()
		local name = getGameName()
		if gLbl.Parent then gLbl.Text = name end
		if gDot.Parent then tween(gDot, 0.3, { BackgroundColor3 = isGameSupported() and C.good or C.err }) end
	end)
	task.delay(0.4, function()
		tween(card, 0.6, { Position = UDim2.fromOffset(16, 26) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	end)
	local glowD = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(CX, CY),
		Size = UDim2.fromOffset(150, 150), BackgroundColor3 = Color3.new(1, 1, 1),
		BackgroundTransparency = 0.94, BorderSizePixel = 0,
	}, mainWin)
	new("UICorner", { CornerRadius = UDim.new(0.5, 0) }, glowD)
	task.spawn(function()
		while alive(mainWin) do
			tween(glowD, 1.5, { BackgroundTransparency = 0.88, Size = UDim2.fromOffset(172, 172) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			task.wait(1.5)
			tween(glowD, 1.5, { BackgroundTransparency = 0.96, Size = UDim2.fromOffset(146, 146) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			task.wait(1.5)
		end
	end)
	local logo = makeLogo(mainWin, 116, UDim2.fromOffset(CX, CY), Vector2.new(0.5, 0.5))
	local logoScale = new("UIScale", { Scale = 0 }, logo)
	task.delay(0.3, function() tween(logoScale, 0.7, { Scale = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out) end)
	task.spawn(function()
		local t = 0
		while alive(mainWin) do
			t += task.wait()
			logo.Position = UDim2.fromOffset(CX, CY + math.sin(t * 2) * 4)
			logo.Rotation = math.sin(t * 1.5) * 2
		end
	end)
	local ringBase = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(CX, CY),
		Size = UDim2.fromOffset(152, 152), BackgroundTransparency = 1,
	}, mainWin)
	corner(ringBase, 76)
	stroke(ringBase, C.stroke, 1, 0.2)
	local spin = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(CX, CY),
		Size = UDim2.fromOffset(152, 152), BackgroundTransparency = 1,
	}, mainWin)
	corner(spin, 76)
	local spinStroke = stroke(spin, Color3.new(1, 1, 1), 2.5, 0)
	local spinGrad = new("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.45, 1),
			NumberSequenceKeypoint.new(0.8, 0.4), NumberSequenceKeypoint.new(1, 0),
		}),
	}, spinStroke)
	task.spawn(function()
		while alive(mainWin) do
			local dt = task.wait()
			spinGrad.Rotation = (spinGrad.Rotation + dt * 300) % 360
		end
	end)
	local pLbl = label(mainWin, S("dashLoading"), 12, UDim2.fromOffset(60, 220), UDim2.fromOffset(W - 180, 18), C.text, Enum.Font.GothamMedium)
	local pctLbl = label(mainWin, "0%", 12, UDim2.fromOffset(W - 120, 220), UDim2.fromOffset(60, 18), C.muted, Enum.Font.GothamBold, Enum.TextXAlignment.Right)
	local track = new("Frame", {
		Position = UDim2.fromOffset(60, 244), Size = UDim2.fromOffset(W - 120, 6),
		BackgroundColor3 = C.field, BorderSizePixel = 0, ZIndex = 2, ClipsDescendants = true,
	}, mainWin)
	corner(track, 3)
	local fill = new("Frame", {
		Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0,
		ZIndex = 3, ClipsDescendants = true,
	}, track)
	corner(fill, 3)
	local fillShine = new("Frame", {
		Position = UDim2.new(-0.4, 0, 0, 0), Size = UDim2.new(0.4, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(150, 150, 160), BackgroundTransparency = 0.3, BorderSizePixel = 0, ZIndex = 4,
	}, fill)
	new("UIGradient", {
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1),
		}),
	}, fillShine)
	task.spawn(function()
		while alive(mainWin) do
			fillShine.Position = UDim2.new(-0.4, 0, 0, 0)
			tween(fillShine, 0.9, { Position = UDim2.new(1, 0, 0, 0) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			task.wait(1.3)
		end
	end)
	local loaderConn
	loaderConn = RunService.RenderStepped:Connect(function()
		if not alive(mainWin) then
			if loaderConn then loaderConn:Disconnect() end
			return
		end
		local trackW = track.AbsoluteSize.X
		local fillW = fill.AbsoluteSize.X
		if trackW > 0 then
			local ratio = math.clamp(fillW / trackW, 0, 1)
			pctLbl.Text = math.floor(ratio * 100 + 0.5) .. "%"
		end
	end)
	local steps = { S("stepLicense"), S("stepGame"), S("stepMenu") }
	local stepItems = {}
	local sw = (W - 120) / #steps
	for i, name in ipairs(steps) do
		local x = 60 + (i - 1) * sw
		local dotF = new("Frame", {
			Position = UDim2.fromOffset(x, 267), Size = UDim2.fromOffset(10, 10),
			BackgroundColor3 = C.field, BorderSizePixel = 0, ZIndex = 3,
		}, mainWin)
		corner(dotF, 5)
		local dst = stroke(dotF, C.stroke, 1)
		local lbl = label(mainWin, name, 10, UDim2.fromOffset(x + 16, 262), UDim2.fromOffset(sw - 20, 20), C.muted, Enum.Font.GothamMedium)
		lbl.TextTruncate = Enum.TextTruncate.AtEnd
		stepItems[i] = { dot = dotF, st = dst, lbl = lbl }
	end
	local function stepState(i, done)
		local it = stepItems[i]
		local col = done and C.good or Color3.new(1, 1, 1)
		tween(it.dot, 0.25, { BackgroundColor3 = col })
		tween(it.st, 0.25, { Color = col })
		tween(it.lbl, 0.25, { TextColor3 = C.text })
	end
	local chips = {
		{ S("lblUser"), tostring(username) },
		{ S("expires"), expiresText(expires) },
		{ S("lblDEVICE"), deviceId() },
	}
	local GAP = 8
	local cw = (W - 32 - GAP * (#chips - 1)) / #chips
	local chipY = H - 66
	for i, c in ipairs(chips) do
		local x = 16 + (i - 1) * (cw + GAP)
		local chip = new("Frame", {
			Position = UDim2.fromOffset(x, H + 10), Size = UDim2.fromOffset(cw, 50),
			BackgroundColor3 = C.panel, BorderSizePixel = 0, ZIndex = 3,
		}, mainWin)
		corner(chip, 8)
		stroke(chip, C.stroke, 1)
		label(chip, c[1], 9, UDim2.fromOffset(10, 8), UDim2.fromOffset(cw - 20, 12), C.muted, Enum.Font.Gotham)
		local v = label(chip, c[2], 12, UDim2.fromOffset(10, 23), UDim2.fromOffset(cw - 20, 20), C.text, Enum.Font.GothamBold)
		if i == 2 then
			v.Visible = false
			makeExpiry(chip, UDim2.fromOffset(10, 23), cw - 20, 20, 12).set("", expires)
		else
			v.TextTruncate = Enum.TextTruncate.AtEnd
		end
		task.delay(0.8 + i * 0.1, function()
			if alive(chip) then
				tween(chip, 0.55, { Position = UDim2.fromOffset(x, chipY) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
			end
		end)
	end
	task.delay(0.9, function()
		for i, name in ipairs(steps) do
			if not alive(mainWin) then return end
			pLbl.Text = name
			stepState(i, false)
			tween(fill, 0.7, { Size = UDim2.new(i / #steps, 0, 1, 0) }, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			task.wait(0.85)
			stepState(i, true)
		end
		if not alive(mainWin) then return end
		pLbl.Text = S("dashReady")
		pLbl.TextColor3 = C.good
		pctLbl.Text = "100%"
		pctLbl.TextColor3 = C.good
		tween(fill, 0.4, { BackgroundColor3 = C.good })
		if loaderConn then loaderConn:Disconnect() end
		local burst = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromOffset(CX, CY),
			Size = UDim2.fromOffset(152, 152), BackgroundTransparency = 1,
		}, mainWin)
		corner(burst, 300)
		local bs = stroke(burst, C.good, 2, 0.1)
		tween(burst, 0.8, { Size = UDim2.fromOffset(460, 460) })
		tween(bs, 0.8, { Transparency = 1 })
		task.wait(0.8)
		tween(mainWin, 0.4, { Size = UDim2.fromOffset(W, 0) }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
		task.wait(0.45)
		mainWin:Destroy()
		openHub(username, rank, expires, expiresAt)
	end)
	tween(mainWin, 0.6, { Size = UDim2.fromOffset(W, H) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

---------------------------------------------------------------------
-- AUTHENTIFICATION API
---------------------------------------------------------------------
local ERROR_MAP = {
	taken = "userTaken", user_taken = "userTaken", exists = "userTaken", username_taken = "userTaken",
	no_account = "noAccount", not_found = "noAccount", unknown_user = "noAccount",
	bad_credentials = "badCreds", wrong_password = "badCreds", invalid_credentials = "badCreds",
	account_expired = "expired",
	hwid_mismatch = "hwid", hwid_locked = "hwid",
	rate_limited = "rate", too_many_requests = "rate",
}

local function mapError(code, signup)
	code = tostring(code or "invalid")
	if ERROR_MAP[code] then return ERROR_MAP[code] end
	if code == "invalid" then return "badCreds" end
	if Lang.EN[code] then return code end
	return "errServer"
end

local function authRequest(mode, username, password)
	if not globalRequest then
		return { valid = false, error = "noRequest" }
	end
	local path = (mode == "signup") and Config.RegisterPath or Config.LoginPath
	local response = httpJson(path, {
		username = username,
		password = password,
		hwid = deviceId(),
	}, 8, 5)
	if not response then
		return { valid = false, error = "errServer" }
	end
	local data = response
	if type(response) == "table" and #response > 0 then
		data = response[1]
	end
	if type(data) ~= "table" then
		return { valid = false, error = "errServer" }
	end
	if data.valid == true or data.ok == true or data.success == true then
		local exp = data.expires
		if exp == nil then exp = "Lifetime" end
		local expAt = (type(data.expiresAt) == "number") and data.expiresAt or nil
		return {
			valid = true, rank = data.rank or "Standard", expires = exp, expiresAt = expAt,
		}
	end
	return { valid = false, error = mapError(data.error, mode == "signup") }
end

local function checkSavedKey()
	local success, content = pcall(function()
		if isfile and isfile(Config.KeyFile) and readfile then return readfile(Config.KeyFile) end
	end)
	if success and content then
		local ok, data = pcall(function() return HttpService:JSONDecode(content) end)
		if ok and type(data) == "table" then
			if data.Remember == false then
				setRemember(false, true)
			else
				if data.Username then userBox.Text = data.Username end
				if data.Password then passBox.Text = data.Password end
			end
		end
	end
end

---------------------------------------------------------------------
-- LOGIQUE INTERFACE & LANGUES
---------------------------------------------------------------------
local statusKey
local function setStatus(key, good)
	statusKey = key
	status.TextColor3 = good and C.good or C.err
	status.Text = key and S(key) or ""
	if key then
		status.Position = UDim2.fromOffset(0, Y_STATUS + 4)
		status.TextTransparency = 1
		tween(status, 0.3, { Position = UDim2.fromOffset(0, Y_STATUS), TextTransparency = 0 }, Enum.EasingStyle.Back)
	end
end

discordBtn.MouseButton1Click:Connect(function()
	openDiscord()
	setStatus("copied", true)
end)
getKeyBtn.MouseButton1Click:Connect(function()
	openDiscord()
	setStatus("copied", true)
end)

local firstRefresh = true
local function refresh()
	if firstRefresh then
		typeText(title, isSignup and S("signup") or S("welcome"))
		typeText(subtitle, isSignup and S("subSignup") or S("sub"))
		firstRefresh = false
	else
		title.Text = isSignup and S("signup") or S("welcome")
		subtitle.Text = isSignup and S("subSignup") or S("sub")
	end
	submitText.Text = isSignup and S("signup") or S("signin")
	getKeyText.Text = S("getKeyBtn")
	userBox.PlaceholderText = S("userPh")
	for _, f in ipairs(maskUpdaters) do f() end
	rememberLbl.Text = S("remember")
	updateGameBadge()
	tabSignin.Text = S("signin")
	tabSignup.Text = S("signup")
	if statusKey then status.Text = S(statusKey) end
	tween(tabPill, 0.35, { Position = UDim2.fromOffset(isSignup and 153 or 3, 3) }, Enum.EasingStyle.Back)
	tabSignin.TextColor3 = not isSignup and C.text or C.muted
	tabSignup.TextColor3 = isSignup and C.text or C.muted
	if isSignup and not getKeyBtn.Visible then
		getKeyBtn.Position = UDim2.fromOffset(0, Y_GETKEY + 20)
		getKeyBtn.Visible = true
		tween(getKeyBtn, 0.45, { Position = UDim2.fromOffset(0, Y_GETKEY) }, Enum.EasingStyle.Back)
	elseif not isSignup then
		getKeyBtn.Visible = false
	end
	for code, b in pairs(langBtns) do
		local on = code == currentLang
		b.TextColor3 = on and C.text or C.muted
		tween(langStrokes[code], 0.2, { Color = on and C.text or C.stroke })
	end
end

tabSignin.MouseButton1Click:Connect(function() isSignup = false; setStatus(nil); refresh() end)
tabSignup.MouseButton1Click:Connect(function() isSignup = true; setStatus(nil); refresh() end)

for code, b in pairs(langBtns) do
	b.MouseButton1Click:Connect(function()
		currentLang = code
		saveLang()
		refresh()
	end)
end

local function flashError(...)
	local sts = { ... }
	if #sts == 0 then sts = { userStroke, passStroke } end
	for _, st in ipairs(sts) do
		tween(st, 0.15, { Color = C.err })
		task.delay(0.8, function() tween(st, 0.3, { Color = C.stroke }) end)
	end
end

local working = false
local function doSubmit()
	if working then return end
	if not globalRequest then
		flashError()
		return setStatus("noRequest")
	end
	local enteredUser = userBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
	local enteredPass = passBox.Text
	if enteredUser == "" then flashError(userStroke); return setStatus("emptyUser") end
	if enteredPass == "" then flashError(passStroke); return setStatus("emptyPass") end
	if isSignup and #enteredPass < 4 then flashError(passStroke); return setStatus("shortPass") end
	working = true
	setStatus(nil)
	submitText.Text = S("verifying")
	task.spawn(function()
		local base = S("verifying"):gsub("%.+$", "")
		local d = 0
		while working do
			submitText.Text = base .. string.rep(".", d)
			d = (d + 1) % 4
			task.wait(0.3)
		end
	end)
	task.spawn(function()
		local res = authRequest(isSignup and "signup" or "signin", enteredUser, enteredPass)
		working = false
		if res.valid then
			Session.password = enteredPass
			if writefile then
				pcall(function()
					if remember then
						writefile(Config.KeyFile, HttpService:JSONEncode({
							Username = enteredUser, Password = enteredPass, Remember = true,
						}))
					else
						writefile(Config.KeyFile, HttpService:JSONEncode({ Remember = false }))
					end
				end)
			end
			submitText.Text = S("granted") .. " ✓"
			tween(submit, 0.3, { BackgroundColor3 = C.good })
			setStatus("granted", true)
			task.wait(0.7)
			tween(window, 0.35, { Size = UDim2.fromOffset(744, 0) }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
			task.wait(0.4)
			window:Destroy()
			openMainDashboard(enteredUser, res.rank, res.expires, res.expiresAt)
		else
			task.wait(0.35)
			submitText.Text = isSignup and S("signup") or S("signin")
			setStatus(res.error or "badCreds")
			flashError()
			local p = window.Position
			for _, dx in ipairs({ 8, -8, 6, -6, 3, -3, 0 }) do
				window.Position = UDim2.new(p.X.Scale, p.X.Offset + dx, p.Y.Scale, p.Y.Offset)
				task.wait(0.02)
			end
		end
	end)
end

submit.MouseButton1Click:Connect(doSubmit)
passBox.FocusLost:Connect(function(enter) if enter then doSubmit() end end)
userBox.FocusLost:Connect(function(enter) if enter then passBox:CaptureFocus() end end)

---------------------------------------------------------------------
-- INTRO
---------------------------------------------------------------------
local function slideIn(obj, delay)
	local final = obj.Position
	obj.Position = UDim2.new(final.X.Scale, final.X.Offset - 36, final.Y.Scale, final.Y.Offset)
	task.delay(delay, function()
		tween(obj, 0.5, { Position = final }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	end)
end

checkSavedKey()
refresh()
window.Size = UDim2.fromOffset(744, 0)
tween(window, 0.6, { Size = UDim2.fromOffset(744, 466) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

slideIn(title, 0.35)
slideIn(subtitle, 0.42)
slideIn(tabContainer, 0.5)
slideIn(userField, 0.58)
slideIn(passField, 0.66)
slideIn(rememberBtn, 0.74)
slideIn(submit, 0.82)
