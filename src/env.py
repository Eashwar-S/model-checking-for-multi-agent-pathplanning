import pygame
import time
import math
import numpy as np


def triangleCoordinates(start, end, triangleSize=5):
    rotation = (math.atan2(start[1] - end[1], end[0] - start[0])) + math.pi / 2
    rad = math.pi / 180
    coordinateList = np.array([[end[0], end[1]],
                               [end[0] + triangleSize * math.sin(rotation - 165 * rad),
                                end[1] + triangleSize * math.cos(rotation - 165 * rad)],
                               [end[0] + triangleSize * math.sin(rotation + 165 * rad),
                                end[1] + triangleSize * math.cos(rotation + 165 * rad)]])

    return coordinateList


scale = 30  # scale of grid
# f = open("../output files/output1.txt", "r")
# start = [[1 * scale, 1 * scale], [1 * scale, 19 * scale], [19 * scale, 19 * scale]]  # Starting position of the robots
# goal = [[10 * scale, 19 * scale], [19 * scale, 1 * scale], [10 * scale, 2 * scale]]  # Goal position of the robots
# robots = {0: [], 1: [], 2: []}

# f = open("../output files/output2.txt", "r")
# start = [[1 * scale, 1 * scale], [1 * scale, 19 * scale], [19 * scale, 19 * scale]]  # Starting position of the robots
# goal = [[1 * scale, 18 * scale], [1 * scale, 2 * scale], [10 * scale, 2 * scale]]  # Goal position of the robots
# robots = {0: [], 1: [], 2: []}

f = open("../output files/output4.txt", "r")
start = [[1 * scale, 1 * scale], [1 * scale, 19 * scale], [19 * scale, 19 * scale], [19 * scale, 1 * scale]]  # Starting position of the robots
goal = [[1 * scale, 18 * scale], [1 * scale, 2 * scale], [10 * scale, 2 * scale], [10 * scale, 18 * scale]]  # Goal position of the robots
robots = {0: [], 1: [], 2: [], 3: []}

# f = open("../output files/output3.txt", "r")
# start = [[1 * scale, 1 * scale], [1 * scale, 19 * scale], [1 * scale, 3 * scale]]  # Starting position of the robots
# goal = [[1 * scale, 18 * scale], [1 * scale, 2 * scale], [1 * scale, 17 * scale]]  # Goal position of the robots
# robots = {0: [], 1: [], 2: []}


#


for x in f:
    l = x.split()
    k = 0
    for i in range(0, len(l), 2):
        robots[k].append([int(l[i]), int(l[i + 1])])
        k += 1
f.close()
print(robots)
clearance = 10
radius = 0
stepSize = 11
startTime = time.time()  # Start time of simulation
threshDistance = stepSize  # Step size of movement
res = 1  # resolution of grid
scale = 30  # scale of grid
threshAngle = 45  # Angle between actions
startOrientation = 0
white = (255, 255, 255)
black = (0, 0, 0)
red = (255, 0, 0)
green = (0, 102, 0)
orange = (255, 140, 0)
blue = (0, 0, 255)
purple = (75, 0, 130)
yellow = (255, 255, 0)
pink = (255, 20, 147)
cyan = (0, 255, 255)
maroon = (128, 0, 0)
pathColours = [red, green, blue, maroon]
colors = [green, orange, yellow, cyan]
solutionPaths = []
size_x = 20
size_y = 20
colorr = None

pygame.init()
gameDisplay = pygame.display.set_mode((size_x * scale, size_y * scale))
gameDisplay.fill(white)
pygame.display.set_caption("Spin Counter Example Visualization")
basicfont = pygame.font.SysFont('timesnewroman', 23, bold=True)
############################################################
#                 Display Obstacles
############################################################
pygame.draw.rect(gameDisplay, black, [int(scale * 3), int(scale * 3), int(scale * 3), int(scale * 3)])  # plus
pygame.draw.rect(gameDisplay, black, [int(scale * 15), int(scale * 3), int(scale * 3), int(scale * 3)])  # plus
pygame.draw.rect(gameDisplay, black, [int(scale * 3), int(scale * 15), int(scale * 3), int(scale * 3)])  # |
pygame.draw.rect(gameDisplay, black, [int(scale * 15), int(scale * 15), int(scale * 3), int(scale * 3)])  # -
# pygame.draw.rect(gameDisplay, black, [int(scale * 16), int(scale * 8), int(scale * 0.25), int(scale * 2.5)])  # |
# pygame.draw.rect(gameDisplay, black, [int(scale * 17), int(scale * 9), int(scale * 1.5), int(scale * 0.25)])  # -
# pygame.draw.rect(gameDisplay, black, [int(scale * 9), int(scale * 3), int(scale * 2.5), int(scale * 0.25)])  # -
# pygame.draw.rect(gameDisplay, black,
#                  [int(scale * 10.15), int(scale * 0.8), int(scale * 0.25), int(scale * 1.5)])  # |
# pygame.draw.rect(gameDisplay, black, [int(scale * 9), int(scale * 15), int(scale * 2.5), int(scale * 0.25)])  # -
# pygame.draw.rect(gameDisplay, black,
#                  [int(scale * 10.15), int(scale * 16), int(scale * 0.25), int(scale * 1.5)])  # |
for i in range(len(start)):
    pygame.draw.circle(gameDisplay, pathColours[i], start[i], 0.18 * scale)
    pygame.draw.circle(gameDisplay, pathColours[i], goal[i], 0.18 * scale)
    text = basicfont.render('s' + str(i + 1), False, pathColours[i])
    text1 = basicfont.render('g' + str(i + 1), False, pathColours[i])
    gameDisplay.blit(text, (start[i][0] + 5, start[i][1] + 5))
    gameDisplay.blit(text1, (goal[i][0] + 5, goal[i][1] + 5))
    pygame.display.update()
i = 0
x = np.zeros(len(start))
print(x)
y = np.zeros(len(start))
x2 = np.zeros(len(start))
y2 = np.zeros(len(start))
while i < len(robots[0]):
    for j in range(len(start)):
        x[j], y[j] = robots[j][i]
        x[j] = x[j] * scale
        y[j] = y[j] * scale
        if i == 0:
            x2[j], y2[j] = x[j], y[j]
        else:
            pygame.draw.line(gameDisplay, pathColours[j], (x2[j], y2[j]), (x[j], y[j]), 2)
            # triangle = triangleCoordinates([x2[j], y2[j]], [x[j], y[j]], 10)
            # pygame.draw.polygon(gameDisplay, pathColours[j],
            #                     [tuple(triangle[0]), tuple(triangle[1]), tuple(triangle[2])])
            x2[j], y2[j] = x[j], y[j]
        pygame.draw.circle(gameDisplay, pathColours[j], (int(x[j] * res), int(y[j] * res)),
                           math.floor(3 * 1.5 * res))
        pygame.time.delay(100)
        pygame.display.update()
    i += 1

pygame.time.delay(10000)
pygame.quit()
