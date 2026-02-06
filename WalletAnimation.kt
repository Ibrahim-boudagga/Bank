import android.annotation.SuppressLint
import android.app.Activity
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.CubicBezierEasing
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.spring
import androidx.compose.animation.core.tween
import androidx.compose.animation.rememberSplineBasedDecay
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.AnchoredDraggableState
import androidx.compose.foundation.gestures.DraggableAnchors
import androidx.compose.foundation.gestures.Orientation
import androidx.compose.foundation.gestures.anchoredDraggable
import androidx.compose.foundation.gestures.animateTo
import androidx.compose.foundation.gestures.draggable
import androidx.compose.foundation.gestures.rememberDraggableState
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.WindowInsets
import androidx.compose.foundation.layout.asPaddingValues
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.statusBars
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.ArrowForwardIos
import androidx.compose.material.icons.filled.ArrowUpward
import androidx.compose.material.icons.filled.Close
import androidx.compose.material.icons.filled.Notifications
import androidx.compose.material.icons.filled.Security
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material.icons.rounded.ArrowDownward
import androidx.compose.material.icons.rounded.ArrowUpward
import androidx.compose.material.icons.rounded.AttachMoney
import androidx.compose.material.icons.rounded.Bolt
import androidx.compose.material.icons.rounded.ChevronRight
import androidx.compose.material.icons.rounded.DirectionsCar
import androidx.compose.material.icons.rounded.FitnessCenter
import androidx.compose.material.icons.rounded.Movie
import androidx.compose.material.icons.rounded.MusicNote
import androidx.compose.material.icons.rounded.Person
import androidx.compose.material.icons.rounded.PhoneIphone
import androidx.compose.material.icons.rounded.Savings
import androidx.compose.material.icons.rounded.ShoppingCart
import androidx.compose.material3.Button
import androidx.compose.material3.ButtonDefaults
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.derivedStateOf
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.alpha
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawWithContent
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.BlendMode
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.CompositingStrategy
import androidx.compose.ui.graphics.Path
import androidx.compose.ui.graphics.SolidColor
import androidx.compose.ui.graphics.TileMode
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.drawscope.clipPath
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalConfiguration
import androidx.compose.ui.platform.LocalDensity
import androidx.compose.ui.platform.LocalView
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.IntOffset
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.lerp
import androidx.compose.ui.unit.sp
import androidx.compose.ui.util.lerp
import androidx.core.view.WindowInsetsControllerCompat
import kotlinx.coroutines.launch
import kotlin.math.roundToInt
import kotlin.math.sqrt

/**
 * State used for the expandable "Dynamic Island" sheet.
 */
enum class BlobState { Collapsed, Expanded }

val SpaceStart = Color(0xFF1E1B4B)
val SpaceEnd = Color(0xFF020617)
val TextPrimary = Color(0xFFF8FAFC)
val TextSecondary = Color(0xFF94A3B8)
val PlatinumBase = Color(0xFFE2E8F0)
val PlatinumDark = Color(0xFFCBD5E1)
val ElectricAccent = Color(0xFF6366F1)
val SilverText = Color(0xFF9CA3AF)
val SpecularWhite = Color(0xFFFFFFFF).copy(alpha = 0.8f)

val IridescentBorder = Brush.linearGradient(
    colors = listOf(
        Color(0xFF818CF8).copy(alpha = 0.5f),
        Color(0xFFC084FC).copy(alpha = 0.3f),
        Color(0xFFFFFFFF).copy(alpha = 0.1f)
    )
)

val GlassSurface = Color(0xFFFFFFFF).copy(alpha = 0.05f)

/**
 * Root wallet experience composed of:
 * - Background profile screen
 * - Foreground wallet surface that rolls down/up
 * - Shared profile avatar that morphs between screens
 */
@OptIn(ExperimentalFoundationApi::class)
@Composable
fun WalletAnimation() {
    val density = LocalDensity.current
    val config = LocalConfiguration.current
    val scope = rememberCoroutineScope()
    val view = LocalView.current

    val screenHeightDp = config.screenHeightDp.dp
    val screenWidthDp = config.screenWidthDp.dp

    val rollTargetPx = with(density) { (screenHeightDp * 0.75f).toPx() }

    val screenRollOffset = remember { Animatable(0f) }
    var isProfileOpen by remember { mutableStateOf(false) }

    var islandExpansionProgress by remember { mutableFloatStateOf(0f) }

    val baseTopPadding = WindowInsets.statusBars.asPaddingValues().calculateTopPadding()

    val progress by remember {
        derivedStateOf { (screenRollOffset.value / rollTargetPx).coerceIn(0f, 1f) }
    }

    LaunchedEffect(progress) {
        val window = (view.context as Activity).window
        val controller = WindowInsetsControllerCompat(window, view)
        controller.isAppearanceLightStatusBars = progress < 0.5f
    }

    fun toggleProfile() {
        scope.launch {
            if (isProfileOpen) {
                screenRollOffset.animateTo(0f, spring(dampingRatio = 0.85f, stiffness = 300f))
                isProfileOpen = false
            } else {
                isProfileOpen = true
                screenRollOffset.animateTo(
                    rollTargetPx,
                    spring(dampingRatio = 0.75f, stiffness = 160f)
                )
            }
        }
    }

    BoxWithConstraints(
        modifier = Modifier
            .fillMaxSize()
            .background(SpaceEnd)
    ) {
        ProfileScreenContent(
            isOpen = isProfileOpen,
            progress = progress,
            topPadding = baseTopPadding
        )

        Box(
            modifier = Modifier
                .fillMaxSize()
                .offset { IntOffset(0, screenRollOffset.value.roundToInt()) }
                .graphicsLayer { compositingStrategy = CompositingStrategy.Offscreen }
                .drawWithContent {
                    val rollPx = screenRollOffset.value
                    if (rollPx <= 1f) {
                        drawContent()
                        return@drawWithContent
                    }
                    val width = size.width
                    val cylinderDiameter = (sqrt(rollPx) * 3.6f).coerceAtLeast(1f)

                    drawContent()
                    drawRect(
                        brush = Brush.verticalGradient(
                            listOf(Color.Black.copy(0.6f), Color.Transparent),
                            startY = 0f,
                            endY = cylinderDiameter * 1.5f
                        ),
                        size = Size(width, cylinderDiameter * 1.5f)
                    )
                    drawRect(
                        brush = Brush.verticalGradient(
                            0.0f to Color(0xFFD1D5DB),
                            0.3f to Color(0xFFFFFFFF),
                            0.6f to Color(0xFFE5E7EB),
                            1.0f to Color(0xFF9CA3AF),
                            startY = -cylinderDiameter,
                            endY = 0f
                        ),
                        topLeft = Offset(0f, -cylinderDiameter),
                        size = Size(width, cylinderDiameter)
                    )
                }
        ) {
            HomeContent(
                topPadding = baseTopPadding,
                onProfileClick = { toggleProfile() },
                progress = progress,
                onIslandProgress = { islandExpansionProgress = it }
            )
        }

        val avatarAlpha = (1f - (islandExpansionProgress * 6f)).coerceIn(0f, 1f)

        if (avatarAlpha > 0f) {
            SharedProfileAvatar(
                progress = progress,
                screenWidth = screenWidthDp,
                topPadding = baseTopPadding,
                alpha = avatarAlpha,
                onClick = { toggleProfile() }
            )
        }
    }
}

/**
 * Shared element avatar that interpolates between the wallet and profile states.
 */
@Composable
fun SharedProfileAvatar(
    progress: Float,
    screenWidth: Dp,
    topPadding: Dp,
    alpha: Float,
    onClick: () -> Unit
) {
    val startSize = 52.dp
    val startX = 24.dp
    val startY = topPadding + 2.dp

    val endSize = 100.dp
    val endX = (screenWidth - endSize) / 2
    val endY = topPadding + 80.dp

    val currentSize = lerp(startSize, endSize, progress)
    val currentX = lerp(startX, endX, progress)
    val currentY = lerp(startY, endY, progress)

    val currentBorderWidth = lerp(1.dp, 2.dp, progress)
    val currentBorderBrush = if (progress < 0.5f) {
        IridescentBorder
    } else {
        SolidColor(Color.White.copy(alpha = 0.5f))
    }

    val currentShadow = lerp(0.dp, 20.dp, progress)
    val currentIconSize = lerp(24.dp, 48.dp, progress)

    Box(
        modifier = Modifier
            .offset { IntOffset(currentX.roundToPx(), currentY.roundToPx()) }
            .size(currentSize)
            .graphicsLayer { this.alpha = alpha }
            .shadow(currentShadow, CircleShape, spotColor = ElectricAccent)
            .background(
                Brush.linearGradient(
                    colors = listOf(SpaceStart, SpaceEnd),
                    start = Offset(0f, 0f),
                    end = Offset(0f, 100f)
                ),
                CircleShape
            )
            .border(currentBorderWidth, currentBorderBrush, CircleShape)
            .clip(CircleShape)
            .clickable(
                interactionSource = remember { MutableInteractionSource() },
                indication = null
            ) { onClick() },
        contentAlignment = Alignment.Center
    ) {
        Icon(
            imageVector = Icons.Rounded.Person,
            contentDescription = "Profile",
            tint = Color.White,
            modifier = Modifier.size(currentIconSize)
        )
    }
}

/**
 * Profile screen content rendered beneath the rolling wallet surface.
 */
@Composable
fun ProfileScreenContent(
    isOpen: Boolean,
    progress: Float,
    topPadding: Dp
) {
    val alpha = progress
    val scale = lerp(0.92f, 1f, progress)
    val slideY = lerp(50.dp, 0.dp, progress)
    val scrollState = rememberScrollState()

    Box(
        modifier = Modifier
            .fillMaxSize()
            .graphicsLayer {
                this.alpha = alpha
                this.scaleX = scale
                this.scaleY = scale
            }
    ) {
        Column(
            modifier = Modifier
                .fillMaxWidth()
                .padding(top = topPadding)
                .graphicsLayer { translationY = slideY.toPx() }
                .verticalScroll(scrollState)
                .padding(horizontal = 24.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Spacer(Modifier.height(80.dp + 100.dp))
            Spacer(Modifier.height(24.dp))

            Text(
                "Kyriakos Georgiopoulos",
                color = Color.White,
                fontSize = 20.sp,
                fontWeight = FontWeight.Bold
            )
            Spacer(Modifier.height(4.dp))
            Text(
                "Verified Account",
                color = ElectricAccent,
                fontSize = 14.sp,
                fontWeight = FontWeight.Medium
            )

            Spacer(Modifier.height(32.dp))

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                ProfileStatBox(
                    label = "Income",
                    value = "$8.2k",
                    icon = Icons.Rounded.ArrowUpward,
                    color = Color(0xFF22C55E)
                )
                ProfileStatBox(
                    label = "Spent",
                    value = "$3.4k",
                    icon = Icons.Rounded.ArrowDownward,
                    color = Color(0xFFEF4444)
                )
                ProfileStatBox(
                    label = "Saved",
                    value = "$12k",
                    icon = Icons.Rounded.Savings,
                    color = ElectricAccent
                )
            }

            Spacer(Modifier.height(40.dp))

            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                ProfileMenuItem("Account Settings", Icons.Default.Settings)
                ProfileMenuItem("Notifications", Icons.Default.Notifications)
                ProfileMenuItem("Privacy & Security", Icons.Default.Security)
            }

            Spacer(Modifier.height(24.dp))
        }
    }
}

/**
 * Small stat card used in the profile header row.
 */
@Composable
fun ProfileStatBox(label: String, value: String, icon: ImageVector, color: Color) {
    Column(
        modifier = Modifier
            .width(100.dp)
            .background(GlassSurface, RoundedCornerShape(16.dp))
            .border(1.dp, Color.White.copy(0.1f), RoundedCornerShape(16.dp))
            .padding(12.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        Icon(icon, null, tint = color, modifier = Modifier.size(20.dp))
        Spacer(Modifier.height(8.dp))
        Text(value, color = Color.White, fontWeight = FontWeight.Bold, fontSize = 16.sp)
        Text(label, color = TextSecondary, fontSize = 12.sp)
    }
}

/**
 * Clickable menu row used in the profile menu list.
 */
@Composable
fun ProfileMenuItem(text: String, icon: ImageVector, isDestructive: Boolean = false) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .height(56.dp)
            .background(GlassSurface, RoundedCornerShape(12.dp))
            .border(1.dp, Color.White.copy(0.05f), RoundedCornerShape(12.dp))
            .clickable { }
            .padding(horizontal = 16.dp),
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Icon(
                icon,
                null,
                tint = if (isDestructive) Color(0xFFEF4444) else Color.White,
                modifier = Modifier.size(20.dp)
            )
            Spacer(Modifier.width(16.dp))
            Text(
                text,
                color = if (isDestructive) Color(0xFFEF4444) else Color.White,
                fontWeight = FontWeight.Medium
            )
        }
        Icon(
            Icons.Default.ArrowForwardIos,
            null,
            tint = TextSecondary.copy(0.5f),
            modifier = Modifier.size(14.dp)
        )
    }
}

/**
 * Wallet home content shown on the rolling foreground surface, including the expandable "Dynamic Island".
 */
@OptIn(ExperimentalFoundationApi::class)
@Composable
fun HomeContent(
    topPadding: Dp,
    onProfileClick: () -> Unit,
    progress: Float,
    onIslandProgress: (Float) -> Unit
) {
    val density = LocalDensity.current
    val screenWidth = LocalConfiguration.current.screenWidthDp.dp
    val scope = rememberCoroutineScope()

    val startHeight = 56.dp
    val startWidth = 220.dp
    val startRadius = 28.dp
    val endMarginHorizontal = 16.dp
    val endMarginBottom = 96.dp
    val endHeight = LocalConfiguration.current.screenHeightDp.dp - endMarginBottom
    val endWidth = screenWidth - (endMarginHorizontal * 2)
    val endRadius = 42.dp

    val startHeightPx = with(density) { startHeight.toPx() }
    val endHeightPx = with(density) { endHeight.toPx() }

    val anchors = DraggableAnchors {
        BlobState.Collapsed at startHeightPx
        BlobState.Expanded at endHeightPx
    }

    val decayAnimationSpec = rememberSplineBasedDecay<Float>()
    val draggableState = remember {
        AnchoredDraggableState(
            initialValue = BlobState.Collapsed,
            anchors = anchors,
            positionalThreshold = { it * 0.5f },
            velocityThreshold = { with(density) { 100.dp.toPx() } },
            snapAnimationSpec = spring(dampingRatio = 0.85f, stiffness = 250f),
            decayAnimationSpec = decayAnimationSpec
        )
    }

    val currentHeightPx =
        if (draggableState.offset.isNaN()) startHeightPx else draggableState.offset
    val rawProgress =
        ((currentHeightPx - startHeightPx) / (endHeightPx - startHeightPx)).coerceIn(0f, 1f)
    val smoothProgress by animateFloatAsState(targetValue = rawProgress, label = "Smooth")

    LaunchedEffect(smoothProgress) {
        onIslandProgress(smoothProgress)
    }

    val widthCurve = CubicBezierEasing(0.4f, 0.0f, 0.2f, 1.0f)
    val widthProgress = widthCurve.transform(smoothProgress)
    val currentWidth = lerp(startWidth, endWidth, widthProgress)
    val currentRadius = lerp(startRadius, endRadius, widthProgress)

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(Color(0xFFF1F5F9))
    ) {
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(horizontal = 24.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Spacer(Modifier.height(topPadding + startHeight + 24.dp))
            WetPaintCard()
            Spacer(Modifier.height(32.dp))
            BalanceSection()
            Spacer(Modifier.height(48.dp))
            TransactionsList(modifier = Modifier.weight(1f))
        }

        val bubbleSize = 52.dp

        if (progress == 0f) {
            Box(
                modifier = Modifier
                    .padding(top = topPadding + 2.dp, start = 24.dp)
                    .size(bubbleSize)
                    .graphicsLayer { alpha = 1f - smoothProgress }
                    .border(1.dp, IridescentBorder, CircleShape)
                    .background(Color.Transparent, CircleShape)
                    .clip(CircleShape)
                    .clickable { onProfileClick() },
                contentAlignment = Alignment.Center
            ) {}
        }

        Box(
            modifier = Modifier
                .align(Alignment.TopEnd)
                .padding(top = topPadding + 2.dp, end = 24.dp)
                .size(bubbleSize)
                .graphicsLayer { alpha = 1f - smoothProgress }
                .border(1.dp, IridescentBorder, CircleShape)
                .background(
                    Brush.linearGradient(
                        colors = listOf(SpaceStart, SpaceEnd),
                        start = Offset(0f, 0f),
                        end = Offset(0f, 100f)
                    ),
                    CircleShape
                )
                .clip(CircleShape),
            contentAlignment = Alignment.Center
        ) {
            Icon(
                Icons.Default.Add,
                "Add Money",
                tint = Color.White,
                modifier = Modifier.size(24.dp)
            )
        }

        Box(
            modifier = Modifier
                .padding(top = topPadding)
                .offset {
                    IntOffset(
                        ((screenWidth.toPx() - currentWidth.toPx()) / 2).roundToInt(),
                        0
                    )
                }
                .width(currentWidth)
                .height(with(density) { currentHeightPx.toDp() })
                .graphicsLayer {
                    shape = RoundedCornerShape(currentRadius)
                    clip = true
                    shadowElevation = (smoothProgress * 40f)
                    spotShadowColor = Color(0xFF4F46E5).copy(alpha = 0.8f)
                    ambientShadowColor = Color(0xFFC084FC).copy(alpha = 0.8f)
                }
                .background(
                    Brush.linearGradient(
                        colors = listOf(SpaceStart, SpaceEnd),
                        start = Offset(0f, 0f),
                        end = Offset(0f, Float.POSITIVE_INFINITY)
                    )
                )
                .border(
                    width = 1.dp,
                    brush = IridescentBorder,
                    shape = RoundedCornerShape(currentRadius)
                )
                .anchoredDraggable(state = draggableState, orientation = Orientation.Vertical)
        ) {
            BlobContent(
                progress = smoothProgress,
                onClose = { scope.launch { draggableState.animateTo(BlobState.Collapsed) } }
            )
        }
    }
}

/**
 * Content shown inside the expandable "Dynamic Island".
 */
@SuppressLint("RestrictedApi")
@Composable
fun BlobContent(progress: Float, onClose: () -> Unit) {
    Box(Modifier.fillMaxSize()) {
        if (progress < 0.5f) {
            val pillAlpha = (1f - (progress * 5f)).coerceIn(0f, 1f)
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .graphicsLayer { alpha = pillAlpha }
            ) {
                Row(
                    modifier = Modifier
                        .fillMaxWidth()
                        .padding(horizontal = 20.dp)
                        .align(Alignment.Center),
                    horizontalArrangement = Arrangement.SpaceBetween,
                    verticalAlignment = Alignment.CenterVertically
                ) {
                    Row(verticalAlignment = Alignment.CenterVertically) {
                        Text("Send", color = TextSecondary, fontSize = 16.sp, fontWeight = FontWeight.Medium)
                        Spacer(modifier = Modifier.width(4.dp))
                        Text("to", color = TextPrimary, fontSize = 16.sp, fontWeight = FontWeight.Medium)
                    }
                    Row(
                        horizontalArrangement = Arrangement.spacedBy((-8).dp),
                        verticalAlignment = Alignment.CenterVertically
                    ) {
                        for (i in 0..2) {
                            Box(
                                modifier = Modifier
                                    .size(26.dp)
                                    .border(2.dp, SpaceStart, CircleShape)
                                    .clip(CircleShape)
                                    .background(getRandomColor(i)),
                                contentAlignment = Alignment.Center
                            ) {
                                Text(
                                    listOf("A", "S", "J")[i],
                                    fontSize = 10.sp,
                                    fontWeight = FontWeight.Bold,
                                    color = Color.Black.copy(0.6f)
                                )
                            }
                        }
                    }
                }
            }
        }

        val contentAlpha = ((progress - 0.2f) / 0.4f).coerceIn(0f, 1f)
        val contentParallax = (1f - progress) * 100f

        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(24.dp)
                .graphicsLayer {
                    alpha = contentAlpha
                    translationY = contentParallax
                }
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.Top
            ) {
                Column {
                    Text("Send", color = TextSecondary, fontSize = 20.sp)
                    Spacer(modifier = Modifier.height(4.dp))
                    Text(
                        "Money To",
                        color = TextPrimary,
                        fontSize = 34.sp,
                        fontWeight = FontWeight.ExtraBold,
                        letterSpacing = (-1).sp
                    )
                }
                IconButton(
                    onClick = onClose,
                    modifier = Modifier
                        .background(GlassSurface, CircleShape)
                        .border(1.dp, Color.White.copy(0.1f), CircleShape)
                ) {
                    Icon(Icons.Default.Close, null, tint = TextPrimary)
                }
            }

            Spacer(Modifier.height(32.dp))

            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween
            ) {
                val bubbleScale = (progress * 1.2f).coerceIn(0f, 1f)
                Row(
                    modifier = Modifier.graphicsLayer {
                        scaleX = bubbleScale
                        scaleY = bubbleScale
                    },
                    horizontalArrangement = Arrangement.spacedBy(16.dp)
                ) {
                    ContactCircle("Farid", Color(0xFFFF8A65))
                    ContactCircle("Shadi", Color(0xFF29B6F6))
                    ContactCircle("Cyrus", Color(0xFFB9F6CA))
                }
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally,
                    modifier = Modifier.graphicsLayer {
                        scaleX = bubbleScale
                        scaleY = bubbleScale
                    }
                ) {
                    Box(
                        modifier = Modifier
                            .size(60.dp)
                            .border(1.dp, Color.White.copy(0.2f), CircleShape)
                            .clip(CircleShape)
                            .background(Color.White.copy(0.05f)),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(Icons.Default.Add, null, tint = TextPrimary)
                    }
                    Spacer(Modifier.height(8.dp))
                    Text("Add", color = TextSecondary, fontSize = 12.sp)
                }
            }

            Spacer(Modifier.height(32.dp))
            Text("Your Contacts", color = TextPrimary, fontSize = 20.sp, fontWeight = FontWeight.Bold)
            Spacer(Modifier.height(16.dp))

            LazyColumn(
                modifier = Modifier.weight(1f),
                verticalArrangement = Arrangement.spacedBy(12.dp)
            ) {
                items(6) { i ->
                    val start = 0.4f + (i * 0.05f)
                    val end = 1f
                    val itemProgress = ((progress - start) / (end - start)).coerceIn(0f, 1f)
                    val itemScale = lerp(0.8f, 1f, itemProgress)
                    val itemAlpha = itemProgress
                    val itemTranslationY = (1f - itemProgress) * 100f

                    Row(
                        verticalAlignment = Alignment.CenterVertically,
                        modifier = Modifier
                            .fillMaxWidth()
                            .graphicsLayer {
                                alpha = itemAlpha
                                scaleX = itemScale
                                scaleY = itemScale
                                translationY = itemTranslationY
                            }
                            .clip(RoundedCornerShape(22.dp))
                            .background(GlassSurface)
                            .padding(12.dp)
                    ) {
                        Box(
                            modifier = Modifier
                                .size(48.dp)
                                .clip(CircleShape)
                                .background(getRandomColor(i)),
                            contentAlignment = Alignment.Center
                        ) {
                            Text(
                                listOf("A", "C", "J", "W", "D", "M")[i],
                                color = Color.Black.copy(0.6f),
                                fontWeight = FontWeight.Bold
                            )
                        }
                        Spacer(Modifier.width(16.dp))
                        Column(modifier = Modifier.weight(1f)) {
                            Text(
                                listOf(
                                    "Annette Black",
                                    "Cameron Williamson",
                                    "Jane Cooper",
                                    "Wade Warren",
                                    "Devon Lane",
                                    "Molly Sanders"
                                )[i],
                                color = TextPrimary,
                                fontWeight = FontWeight.SemiBold,
                                fontSize = 16.sp
                            )
                            Text("Recent transfer", color = TextSecondary, fontSize = 12.sp)
                        }
                        Icon(Icons.Rounded.ChevronRight, null, tint = TextSecondary.copy(0.5f))
                    }
                }
            }

            val buttonScale = (progress * 1.5f - 0.5f).coerceIn(0f, 1f)
            Button(
                onClick = {},
                modifier = Modifier
                    .fillMaxWidth()
                    .height(64.dp)
                    .graphicsLayer {
                        scaleX = buttonScale
                        scaleY = buttonScale
                        alpha = buttonScale
                    },
                shape = RoundedCornerShape(32.dp),
                colors = ButtonDefaults.buttonColors(
                    containerColor = Color.White,
                    contentColor = Color.Black
                )
            ) {
                Text("Continue", fontWeight = FontWeight.Bold, fontSize = 17.sp)
            }
        }
    }
}

/**
 * Interactive card with a 3D flip gesture and shimmering paint-like front.
 */
@Composable
fun WetPaintCard(modifier: Modifier = Modifier) {
    val rotation = remember { Animatable(0f) }
    val scope = rememberCoroutineScope()
    val density = LocalDensity.current.density

    val normalizedAngle = (rotation.value % 360 + 360) % 360
    val isBackVisible = normalizedAngle in 90f..270f

    val infiniteTransition = rememberInfiniteTransition(label = "Gloss")
    val shimmerPhase by infiniteTransition.animateFloat(
        initialValue = 0f,
        targetValue = 1f,
        animationSpec = infiniteRepeatable(
            animation = tween(3500, easing = LinearEasing),
            repeatMode = RepeatMode.Restart
        ),
        label = "Shimmer"
    )

    val dragStartFace = remember { mutableStateOf(0f) }

    Box(
        modifier = modifier
            .fillMaxWidth()
            .height(240.dp)
            .graphicsLayer {
                rotationY = rotation.value
                cameraDistance = 14f * density
            }
            .draggable(
                state = rememberDraggableState { delta ->
                    scope.launch {
                        val direction = if (isBackVisible) -1f else 1f
                        val current = rotation.value
                        val angleInHalfTurn = ((current - dragStartFace.value) % 180f + 180f) % 180f
                        val distanceFromMid = kotlin.math.abs(angleInHalfTurn - 90f)
                        val magneticFactor = androidx.compose.ui.util.lerp(
                            start = 0.25f,
                            stop = 1f,
                            fraction = (distanceFromMid / 90f).coerceIn(0f, 1f)
                        )
                        val proposed = current + delta * 0.6f * magneticFactor * direction
                        val clamped = proposed.coerceIn(
                            minimumValue = dragStartFace.value - 180f,
                            maximumValue = dragStartFace.value + 180f
                        )
                        rotation.snapTo(clamped)
                    }
                },
                orientation = Orientation.Horizontal,
                onDragStarted = {
                    dragStartFace.value = (rotation.value / 180f).roundToInt() * 180f
                },
                onDragStopped = { velocity ->
                    val current = rotation.value
                    val base = dragStartFace.value
                    val offset = current - base
                    val target = when {
                        velocity > 800f -> base + 180f
                        velocity < -800f -> base - 180f
                        offset > 60f -> base + 180f
                        offset < -60f -> base - 180f
                        else -> base
                    }
                    scope.launch {
                        rotation.animateTo(
                            targetValue = target,
                            animationSpec = spring(dampingRatio = 0.65f, stiffness = 420f)
                        )
                    }
                }
            )
    ) {
        if (isBackVisible) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .graphicsLayer { rotationY = 180f }
            ) {
                WetPaintCardBack()
            }
        } else {
            WetPaintCardFront(shimmerPhase = shimmerPhase)
        }
    }
}


/**
 * Front face of the card with paint path and shimmer.
 */
@Composable
fun WetPaintCardFront(shimmerPhase: Float) {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .shadow(
                elevation = 20.dp,
                shape = RoundedCornerShape(24.dp),
                spotColor = Color.Black.copy(0.4f),
                ambientColor = Color.Black.copy(0.2f)
            )
            .clip(RoundedCornerShape(24.dp))
            .background(
                Brush.linearGradient(
                    colors = listOf(PlatinumBase, PlatinumDark),
                    start = Offset(0f, 0f),
                    end = Offset(0f, Float.POSITIVE_INFINITY)
                )
            )
    ) {
        Canvas(
            modifier = Modifier
                .fillMaxSize()
                .alpha(0.08f)
        ) {
            drawRect(
                brush = Brush.radialGradient(
                    colors = listOf(Color.Black, Color.Transparent),
                    radius = size.width
                ),
                blendMode = BlendMode.Overlay
            )
        }

        Canvas(modifier = Modifier.fillMaxSize()) {
            val width = size.width
            val height = size.height
            val paintPath = Path().apply {
                moveTo(0f, 0f)
                lineTo(width, 0f)
                lineTo(width, height * 0.15f)
                cubicTo(
                    width * 0.96f,
                    height * 0.15f,
                    width * 0.94f,
                    height * 0.20f,
                    width * 0.92f,
                    height * 0.50f
                )
                cubicTo(
                    width * 0.90f,
                    height * 0.65f,
                    width * 0.84f,
                    height * 0.65f,
                    width * 0.82f,
                    height * 0.40f
                )
                cubicTo(
                    width * 0.78f,
                    height * 0.25f,
                    width * 0.72f,
                    height * 0.25f,
                    width * 0.68f,
                    height * 0.60f
                )
                cubicTo(
                    width * 0.66f,
                    height * 0.92f,
                    width * 0.56f,
                    height * 0.92f,
                    width * 0.54f,
                    height * 0.60f
                )
                cubicTo(
                    width * 0.50f,
                    height * 0.30f,
                    width * 0.45f,
                    height * 0.30f,
                    width * 0.42f,
                    height * 0.70f
                )
                cubicTo(
                    width * 0.40f,
                    height * 0.85f,
                    width * 0.30f,
                    height * 0.85f,
                    width * 0.28f,
                    height * 0.55f
                )
                cubicTo(
                    width * 0.25f,
                    height * 0.25f,
                    width * 0.20f,
                    height * 0.25f,
                    width * 0.18f,
                    height * 0.45f
                )
                cubicTo(
                    width * 0.16f,
                    height * 0.55f,
                    width * 0.10f,
                    height * 0.55f,
                    width * 0.08f,
                    height * 0.35f
                )
                cubicTo(width * 0.04f, height * 0.15f, 0f, height * 0.20f, 0f, height * 0.15f)
                close()
            }
            drawPath(
                path = paintPath,
                brush = Brush.verticalGradient(
                    colors = listOf(Color.Black.copy(0.6f), Color.Transparent),
                    startY = height * 0.1f,
                    endY = height
                ),
                style = Stroke(width = 10f)
            )
            drawPath(
                path = paintPath,
                brush = Brush.verticalGradient(
                    colors = listOf(SpaceStart, SpaceEnd),
                    startY = 0f,
                    endY = height
                )
            )
            drawPath(
                path = paintPath,
                brush = Brush.radialGradient(
                    colors = listOf(Color.Transparent, Color.Black.copy(0.4f)),
                    center = Offset(width * 0.6f, height * 0.9f),
                    radius = width * 0.5f
                )
            )
            clipPath(paintPath) {
                val shimmerStart = -width + (width * 3 * shimmerPhase)
                drawRect(
                    brush = Brush.linearGradient(
                        colors = listOf(
                            Color.Transparent,
                            Color.White.copy(0.15f),
                            Color.Transparent
                        ),
                        start = Offset(shimmerStart, 0f),
                        end = Offset(shimmerStart + width * 0.5f, height)
                    )
                )
            }
        }

        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(28.dp),
            verticalArrangement = Arrangement.SpaceBetween
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.Top
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Box(
                        modifier = Modifier
                            .size(20.dp)
                            .background(Color.White, CircleShape)
                    )
                    Spacer(Modifier.width(8.dp))
                    Text(
                        "NEXUS",
                        color = Color.White,
                        fontSize = 22.sp,
                        fontWeight = FontWeight.ExtraBold,
                        letterSpacing = 1.sp
                    )
                }
                Text("VIRTUAL", color = SilverText, fontSize = 10.sp, fontWeight = FontWeight.Bold)
            }
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.Bottom
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        "••",
                        color = ElectricAccent,
                        fontSize = 24.sp,
                        fontWeight = FontWeight.Black,
                        letterSpacing = 2.sp
                    )
                    Text(
                        "1234",
                        color = SpaceStart,
                        fontSize = 20.sp,
                        fontWeight = FontWeight.Bold,
                        fontFamily = FontFamily.Monospace,
                        modifier = Modifier.padding(start = 6.dp, top = 2.dp)
                    )
                }
                Text(
                    "VISA",
                    color = SpaceStart,
                    fontWeight = FontWeight.Black,
                    fontSize = 28.sp,
                    fontStyle = androidx.compose.ui.text.font.FontStyle.Italic,
                    letterSpacing = (-1).sp
                )
            }
        }
    }
}

/**
 * Back face of the card.
 */
@Composable
fun WetPaintCardBack() {
    Box(
        modifier = Modifier
            .fillMaxSize()
            .shadow(
                elevation = 20.dp,
                shape = RoundedCornerShape(24.dp),
                spotColor = Color.Black.copy(0.4f),
                ambientColor = Color.Black.copy(0.2f)
            )
            .clip(RoundedCornerShape(24.dp))
            .background(
                Brush.linearGradient(
                    colors = listOf(PlatinumBase, PlatinumDark),
                    start = Offset(0f, 0f),
                    end = Offset(1000f, 1000f)
                )
            )
    ) {
        Canvas(
            modifier = Modifier
                .fillMaxSize()
                .alpha(0.05f)
        ) {
            drawRect(
                brush = Brush.radialGradient(
                    colors = listOf(Color.Black, Color.Transparent),
                    radius = size.width
                ),
                blendMode = BlendMode.Overlay
            )
        }

        Box(
            modifier = Modifier
                .fillMaxSize()
                .background(
                    Brush.linearGradient(
                        colors = listOf(
                            Color.White.copy(alpha = 0.0f),
                            Color.White.copy(alpha = 0.4f),
                            Color.White.copy(alpha = 0.0f)
                        ),
                        start = Offset(0f, 0f),
                        end = Offset(1000f, 1000f)
                    )
                )
        )

        Column(Modifier.fillMaxSize()) {
            Spacer(Modifier.height(30.dp))
            Box(
                modifier = Modifier
                    .fillMaxWidth()
                    .height(50.dp)
                    .background(
                        Brush.verticalGradient(
                            listOf(
                                Color(0xFF303030),
                                Color(0xFF000000),
                                Color(0xFF000000),
                                Color(0xFF303030)
                            )
                        )
                    )
            )
            Spacer(Modifier.height(24.dp))
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 24.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Box(
                    modifier = Modifier
                        .weight(1f)
                        .height(40.dp)
                        .background(Color.White.copy(alpha = 0.8f), RoundedCornerShape(4.dp))
                        .border(1.dp, Color.White, RoundedCornerShape(4.dp)),
                    contentAlignment = Alignment.CenterStart
                ) {
                    Text(
                        "Authorized Signature",
                        color = Color.Black.copy(0.7f),
                        fontSize = 10.sp,
                        fontStyle = androidx.compose.ui.text.font.FontStyle.Italic,
                        modifier = Modifier.padding(start = 12.dp)
                    )
                }
                Spacer(Modifier.width(12.dp))
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Text(
                        "CVC",
                        color = SpaceStart.copy(0.6f),
                        fontSize = 11.sp,
                        fontWeight = FontWeight.Bold,
                        modifier = Modifier.padding(end = 6.dp)
                    )
                    Box(
                        modifier = Modifier
                            .width(64.dp)
                            .height(36.dp)
                            .background(Color.White, RoundedCornerShape(6.dp))
                            .shadow(2.dp, RoundedCornerShape(6.dp)),
                        contentAlignment = Alignment.Center
                    ) {
                        Text(
                            "892",
                            color = ElectricAccent,
                            fontSize = 16.sp,
                            fontWeight = FontWeight.ExtraBold,
                            fontFamily = FontFamily.Monospace,
                            letterSpacing = 2.sp
                        )
                    }
                }
            }
            Spacer(Modifier.weight(1f))
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(horizontal = 24.dp, vertical = 24.dp)
            ) {
                Text(
                    "CARD HOLDER",
                    color = SpaceStart.copy(0.5f),
                    fontSize = 10.sp,
                    fontWeight = FontWeight.Bold,
                    letterSpacing = 1.sp
                )
                Spacer(Modifier.height(4.dp))
                Text(
                    "KYRIAKOS GEORGIOPOULOS",
                    color = SpaceStart,
                    fontSize = 17.sp,
                    fontWeight = FontWeight.Bold,
                    fontFamily = FontFamily.Serif,
                    letterSpacing = 0.5.sp,
                    maxLines = 1,
                    overflow = androidx.compose.ui.text.style.TextOverflow.Ellipsis
                )
            }
        }
    }
}

/**
 * Balance header with a subtle shimmering percentage badge.
 */
@Composable
fun BalanceSection() {
    val infiniteTransition = rememberInfiniteTransition(label = "BadgeShimmer")
    val shimmerTranslate by infiniteTransition.animateFloat(
        initialValue = -100f,
        targetValue = 400f,
        animationSpec = infiniteRepeatable(
            animation = tween(3500, easing = LinearEasing),
            repeatMode = RepeatMode.Restart
        ),
        label = "Shimmer"
    )

    val badgeBrush = Brush.linearGradient(
        colors = listOf(Color(0xFFDCFCE7), Color(0xFFF0FDF4), Color(0xFFDCFCE7)),
        start = Offset(shimmerTranslate, 0f),
        end = Offset(shimmerTranslate + 50f, 100f),
        tileMode = TileMode.Clamp
    )

    Column(modifier = Modifier.fillMaxWidth(), horizontalAlignment = Alignment.CenterHorizontally) {
        Text(
            "Total Balance",
            color = TextSecondary,
            fontSize = 14.sp,
            fontWeight = FontWeight.Medium
        )
        Spacer(Modifier.height(8.dp))
        Row(
            modifier = Modifier.fillMaxWidth(),
            verticalAlignment = Alignment.CenterVertically,
            horizontalArrangement = Arrangement.Center
        ) {
            Spacer(modifier = Modifier.width(65.dp))
            Text(
                text = "$24,500.00",
                color = SpaceStart,
                fontSize = 34.sp,
                fontWeight = FontWeight.ExtraBold,
                letterSpacing = (-1).sp
            )
            Spacer(Modifier.width(8.dp))
            Box(
                modifier = Modifier
                    .clip(RoundedCornerShape(6.dp))
                    .background(badgeBrush)
                    .border(1.dp, Color(0xFF166534).copy(alpha = 0.1f), RoundedCornerShape(6.dp))
                    .padding(horizontal = 8.dp, vertical = 4.dp)
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(
                        Icons.Default.ArrowUpward,
                        contentDescription = null,
                        tint = Color(0xFF166534),
                        modifier = Modifier.size(12.dp)
                    )
                    Spacer(Modifier.width(2.dp))
                    Text(
                        "2.4%",
                        color = Color(0xFF166534),
                        fontSize = 13.sp,
                        fontWeight = FontWeight.Bold
                    )
                }
            }
        }
    }
}

/**
 * Scrollable list of recent transactions.
 */
@Composable
fun TransactionsList(modifier: Modifier = Modifier) {
    LazyColumn(
        modifier = modifier.fillMaxWidth(),
        contentPadding = PaddingValues(bottom = 24.dp)
    ) {
        item {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(bottom = 16.dp),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(
                    "Recent Transactions",
                    color = SpaceStart,
                    fontSize = 18.sp,
                    fontWeight = FontWeight.Bold
                )
                Text(
                    "See All",
                    color = ElectricAccent,
                    fontSize = 14.sp,
                    fontWeight = FontWeight.SemiBold
                )
            }
        }

        item {
            TransactionItem(
                icon = Icons.Rounded.ShoppingCart,
                title = "Whole Foods Market",
                subtitle = "Groceries • Today",
                amount = "-$124.50",
                iconColor = SpaceStart
            )
        }
        item {
            TransactionItem(
                icon = Icons.Rounded.Movie,
                title = "Netflix Subscription",
                subtitle = "Entertainment • Yesterday",
                amount = "-$15.99",
                iconColor = SpaceStart
            )
        }
        item {
            TransactionItem(
                icon = Icons.Rounded.Bolt,
                title = "Electric Bill",
                subtitle = "Utilities • Feb 12",
                amount = "-$85.00",
                iconColor = SpaceStart
            )
        }
        item {
            TransactionItem(
                icon = Icons.Rounded.AttachMoney,
                title = "Salary Deposit",
                subtitle = "Income • Feb 01",
                amount = "+$4,250.00",
                isPositive = true,
                iconColor = SpaceStart
            )
        }
        item {
            TransactionItem(
                icon = Icons.Rounded.DirectionsCar,
                title = "Uber Ride",
                subtitle = "Transport • Jan 30",
                amount = "-$24.20",
                iconColor = SpaceStart
            )
        }
        item {
            TransactionItem(
                icon = Icons.Rounded.PhoneIphone,
                title = "Apple Store",
                subtitle = "Electronics • Jan 28",
                amount = "-$999.00",
                iconColor = SpaceStart
            )
        }
        item {
            TransactionItem(
                icon = Icons.Rounded.FitnessCenter,
                title = "Equinox Gym",
                subtitle = "Health • Jan 25",
                amount = "-$180.00",
                iconColor = SpaceStart
            )
        }
        item {
            TransactionItem(
                icon = Icons.Rounded.MusicNote,
                title = "Spotify Premium",
                subtitle = "Subscription • Jan 24",
                amount = "-$12.99",
                iconColor = SpaceStart
            )
        }
    }
}

/**
 * Single transaction row.
 */
@Composable
fun TransactionItem(
    icon: ImageVector,
    title: String,
    subtitle: String,
    amount: String,
    isPositive: Boolean = false,
    iconColor: Color = SpaceStart
) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Box(
            modifier = Modifier
                .size(48.dp)
                .shadow(
                    elevation = 2.dp,
                    shape = RoundedCornerShape(14.dp),
                    spotColor = Color.Black.copy(0.1f)
                )
                .background(Color.White, RoundedCornerShape(14.dp)),
            contentAlignment = Alignment.Center
        ) {
            Icon(
                imageVector = icon,
                contentDescription = null,
                tint = iconColor,
                modifier = Modifier.size(24.dp)
            )
        }

        Spacer(Modifier.width(16.dp))

        Column(modifier = Modifier.weight(1f)) {
            Text(title, color = SpaceStart, fontSize = 16.sp, fontWeight = FontWeight.Bold)
            Text(subtitle, color = TextSecondary, fontSize = 12.sp, fontWeight = FontWeight.Medium)
        }

        Text(
            amount,
            color = if (isPositive) Color(0xFF166534) else SpaceStart,
            fontSize = 16.sp,
            fontWeight = FontWeight.Bold
        )
    }
}

/**
 * Circular contact chip used in the expanded island contact row.
 */
@Composable
fun ContactCircle(name: String, color: Color) {
    Column(horizontalAlignment = Alignment.CenterHorizontally) {
        Box(contentAlignment = Alignment.TopEnd) {
            Box(
                modifier = Modifier
                    .size(60.dp)
                    .clip(CircleShape)
                    .background(Brush.verticalGradient(listOf(color, color.copy(alpha = 0.6f)))),
                contentAlignment = Alignment.Center
            ) {
                Icon(
                    Icons.Rounded.Person,
                    null,
                    tint = Color.White,
                    modifier = Modifier.size(28.dp)
                )
            }
            Box(
                modifier = Modifier
                    .padding(2.dp)
                    .size(14.dp)
                    .border(2.dp, SpaceEnd, CircleShape)
                    .clip(CircleShape)
                    .background(Color(0xFF00E676))
            )
        }
        Spacer(Modifier.height(8.dp))
        Text(name, color = TextSecondary, fontSize = 12.sp)
    }
}

/**
 * Deterministic color selection used for placeholder avatars.
 */
fun getRandomColor(index: Int): Color {
    val colors = listOf(
        Color(0xFFFFCC80),
        Color(0xFFEF9A9A),
        Color(0xFF80CBC4),
        Color(0xFF9FA8DA),
        Color(0xFFB39DDB),
        Color(0xFFFFAB91)
    )
    return colors[index % colors.size]
}
