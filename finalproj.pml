/* Set up the envoronment
        1. Considering a 10x10 grid
        2. Defining obstacles
*/  

/*
   Declaration of Parameters
*/
int startx[3];
int starty[3];
int goalx[3];
int goaly[3];
int constraintsx[4];
int constraintsy[4];
int posx[3];
int posy[3];
int prex[3];
int prey[3];
int actionx[4];
int actiony[4];

#define FINALSTATE (FINALSTATE1 && FINALSTATE2 && FINALSTATE3)
#define FINALSTATE1 ((posx[0] == goalx[0]) && (posy[0] == goaly[0]))
#define FINALSTATE2 ((posx[1] == goalx[1]) && (posy[1] == goaly[1]))
#define FINALSTATE3 ((posx[2] == goalx[2]) && (posy[2] == goaly[2]))
#define COLLISION1 ((posx[0] >= constraintsx[0] && posx[0] <= constraintsx[1] && posy[0] >= constraintsy[0] && posy[0] <= constraintsy[1]) || (posx[0] >= constraintsx[0] && posx[0] <= constraintsx[1] && posy[0] >= constraintsy[2] && posy[0] <= constraintsy[3]) || (posx[0] >= constraintsx[2] && posx[0] <= constraintsx[3] && posy[0] >= constraintsy[0] && posy[0] <= constraintsy[1]) || (posx[0] >= constraintsx[2] && posx[0] <= constraintsx[3] && posy[0] >= constraintsy[2] && posy[0] <= constraintsy[3]))
#define COLLISION2 ((posx[1] >= constraintsx[0] && posx[1] <= constraintsx[1] && posy[1] >= constraintsy[0] && posy[1] <= constraintsy[1]) || (posx[1] >= constraintsx[0] && posx[1] <= constraintsx[1] && posy[1] >= constraintsy[2] && posy[1] <= constraintsy[3]) || (posx[1] >= constraintsx[2] && posx[1] <= constraintsx[3] && posy[1] >= constraintsy[0] && posy[1] <= constraintsy[1]) || (posx[1] >= constraintsx[2] && posx[1] <= constraintsx[3] && posy[1] >= constraintsy[2] && posy[1] <= constraintsy[3]))
#define COLLISION3 ((posx[2] >= constraintsx[0] && posx[2] <= constraintsx[1] && posy[2] >= constraintsy[0] && posy[2] <= constraintsy[1]) || (posx[2] >= constraintsx[0] && posx[2] <= constraintsx[1] && posy[2] >= constraintsy[2] && posy[2] <= constraintsy[3]) || (posx[2] >= constraintsx[2] && posx[2] <= constraintsx[3] && posy[2] >= constraintsy[0] && posy[2] <= constraintsy[1]) || (posx[2] >= constraintsx[2] && posx[2] <= constraintsx[3] && posy[2] >= constraintsy[2] && posy[2] <= constraintsy[3]))
#define ENVCOLLISION  (COLLISION1 || COLLISION2 || COLLISION3)                  

#define ROBOTCOLLISION (((posx[0] == posx[1]) && (posy[0] == posy[1])) || ((posx[1] == posx[2]) && (posy[1] == posy[2])) || ((posx[2] == posx[0]) && (posy[2] == posy[0])) || ((posx[0] == posx[1] == posx[2]) && (posy[0] == posy[1] == posy[2])))
#define FEASIBLESTATE1 (posx[0] >= 1 && posx[0] <= 10 && posy[0] >= 1 && posy[0] <= 10)
#define FEASIBLESTATE2 (posx[1] >= 1 && posx[1] <= 10 && posy[1] >= 1 && posy[1] <= 10)
#define FEASIBLESTATE3 (posx[2] >= 1 && posx[2] <= 10 && posy[2] >= 1 && posy[2] <= 10)
#define GOAL (FINALSTATE && !ENVCOLLISION && !ROBOTCOLLISION)


active proctype planner(){
   int count=0;
   count = 0;

   startx[0] = 1;
   startx[1] = 1;
   startx[2] = 19;
   starty[0] = 1;
   starty[1] = 19;
   starty[2] = 19;

   goalx[0] = 10;
   goalx[1] = 19;
   goalx[2] = 1;
   goaly[0] = 18;
   goaly[1] = 1;
   goaly[2] = 2;

   constraintsx[0] = 3;
   constraintsx[1] = 5;
   constraintsx[2] = 15;
   constraintsx[3] = 17;

   constraintsy[0] = 3;
   constraintsy[1] = 5;
   constraintsy[2] = 15;
   constraintsy[3] = 17;

   posx[0] = startx[0];
   posx[1] = startx[1];
   posx[2] = startx[2];
   posy[0] = starty[0];
   posy[1] = starty[1];
   posy[2] = starty[2];

   prex[0] = startx[0];
   prex[1] = startx[1];
   prex[2] = startx[2];
   prey[0] = starty[0];
   prey[1] = starty[1];
   prey[2] = starty[2];
   int i, j, k;

   do
   :: true ->
      if
      :: !(FINALSTATE) ->
         printf("%d %d %d %d %d %d\n", posx[0], posy[0], posx[1], posy[1], posx[2], posy[2]);
         for(i in posx){
            // printf("(posx, posy) before - (%d, %d)\n", posx[i], posy[i]);
            if 
            :: !((posx[i] == goalx[i]) && (posy[i] == goaly[i])) ->
               // up
               actionx[0] = posx[i];
               actiony[0] = posy[i] - 1;
               // down
               actionx[1] = posx[i];
               actiony[1] = posy[i] + 1;
               // left
               actionx[2] = posx[i] - 1;
               actiony[2] = posy[i];
               //right
               actionx[3] = posx[i] + 1;
               actiony[3] = posy[i];
               int cost[4];
               int minicost = 100000;
               int ind1, ind2, ind3;
               for(j in actionx){
                  
                  if
                  :: j == 0 ->
                     ind1 = 1;
                     ind2 = 2;
                  :: j == 1 ->
                     ind1 = 0;
                     ind2 = 2;
                  :: else ->
                     ind1 = 0;
                     ind2 = 1;
                  fi
                  
                  if
                  :: (actionx[j] >= 0 && actionx[j] <= 19 && actiony[j] >= 0 && actiony[j] <= 19) ->
                     if 
                     :: !(((actionx[j] >= constraintsx[0] && actionx[j] <= constraintsx[1] && actiony[j] >= constraintsy[0] && actiony[j] <= constraintsy[1])
                     || (actionx[j] >= constraintsx[0] && actionx[j] <= constraintsx[1] && actiony[j] >= constraintsy[2] && actiony[j] <= constraintsy[3])
                     || (actionx[j] >= constraintsx[2] && actionx[j] <= constraintsx[3] && actiony[j] >= constraintsy[0] && actiony[j] <= constraintsy[1])
                     || (actionx[j] >= constraintsx[2] && actionx[j] <= constraintsx[3] && actiony[j] >= constraintsy[2] && actiony[j] <= constraintsy[3]))
                     && (((actionx[j] == posx[ind1]) && (actiony[j] == posy[ind1])) || ((actionx[j] == posx[ind2]) && (actiony[j] == posy[ind2])))) ->
                        if
                        :: ((actionx[j] - goalx[i]) >= 0) ->
                           cost[j] = cost[j] + actionx[j] - goalx[i];
                        :: else ->
                           cost[j] = cost[j] + goalx[i] - actionx[j];
                        fi

                        if
                        :: ((actiony[j] - goaly[i]) >= 0) ->
                           cost[j] = cost[j] + actiony[j] - goaly[i];
                        :: else ->
                           cost[j] = cost[j] + goaly[i] - actiony[j];
                        fi

                        // printf("(actionx, actiony) - [goalx, goaly] is (%d, %d) - (%d, %d)\n",actionx[j], actiony[j], goalx[i], goaly[i]);
                        // printf("cost - %d\n", cost[j]);
                     fi
                  :: else ->
                     actionx[j] = -1;
                     actionx[j] = -1;
                     cost[j] = -1;
                  fi
               }
               for(j in actionx){
                  if
                  :: (cost[j] != -1 && cost[j] < minicost) ->
                     minicost = cost[j];
                     ind3 = j;
                  :: else ->
                     j = j;
                  fi
               cost[j] = 0;
               }
               // printf("minicost - %d  index - %d\n",minicost, ind3);

               posx[i] = actionx[ind3];
               posy[i] = actiony[ind3];
               // printf("(posx, posy) after - (%d, %d)\n", posx[i], posy[i]);
            :: else ->
               // printf("Robot %d reached the goal\n", i);
               posx[i] = posx[i];
               posy[i] = posy[i];
            fi
         }
         // printf("\n\n");
      :: else ->
         // printf("(%d, %d), (%d, %d), (%d, %d)\n", posx[0], posy[0], posx[1], posy[1], posx[2], posy[2]);
         printf("%d %d %d %d %d %d\n", posx[0], posy[0], posx[1], posy[1], posx[2], posy[2]);
         printf("All robots reached their goals\n");
         break
      fi
   od

}