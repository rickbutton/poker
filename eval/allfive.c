#include <stdio.h>
#include "poker.h"

/*************************************************/
/*                                               */
/* This code tests my evaluator, by looping over */
/* all 2,598,960 possible five card hands, cal-  */
/* culating each hand's distinct value, and dis- */
/* playing the frequency count of each hand type */
/*                                               */
/* Kevin L. Suffecool, 2001                      */
/* suffecool@bigfoot.com                         */
/*                                               */
/*************************************************/

// main()
// {
//     int deck[52], hand[5], freq[10];
//     int a, b, c, d, e, i, j;
// 
//     // seed the random number generator
//     srand48( getpid() );
// 
//     // initialize the deck
//     init_deck( deck );
// 
//     // zero out the frequency array
//     for ( i = 0; i < 10; i++ )
//         freq[i] = 0;
// 
//     // loop over every possible five-card hand
//     for(a=0;a<48;a++)
//     {
//  hand[0] = deck[a];
//  for(b=a+1;b<49;b++)
//  {
//      hand[1] = deck[b];
//      for(c=b+1;c<50;c++)
//      {
//      hand[2] = deck[c];
//      for(d=c+1;d<51;d++)
//      {
//          hand[3] = deck[d];
//          for(e=d+1;e<52;e++)
//          {
//          hand[4] = deck[e];
// 
//          i = eval_5hand( hand );
//          j = hand_rank(i);
//          freq[j]++;
//          }
//      }
//      }
//  }
//     }
// 
//     for(i=1;i<=9;i++)
//  printf( "%15s: %8d\n", value_str[i], freq[i] );
// }

int extract_rank(char c) {
  int rank;
  if (c == 't' || c == 'T')
    rank = 10;
  else if (c == 'j' || c == 'J')
    rank = 11;
  else if (c == 'q' || c == 'Q')
    rank = 12;
  else if (c == 'k' || c == 'K')
    rank = 13;
  else if (c == 'a' || c == 'A')
    rank = 14;
  else if (c >= '2' && c <= '9')
    rank = c - '0';
  else
    rank = 101;
  
  rank -= 2;
  return rank;
}

int extract_suit(char c) {
  int suit;
  if (c == 'c' || c == 'C')
    suit = CLUB;
  else if (c == 'd' || c == 'D')
    suit = DIAMOND;
  else if (c == 'h' || c == 'H')
    suit = HEART;
  else if (c == 's' || c == 'S')
    suit = SPADE;
  else
    suit = 99;
  return suit;
}

int check_format(char *str) {
  if (strlen(str) == 2)
    return 1; // true
  return 0; // false
}

void print_rank(int rank) {
  char *str;
  switch(rank) {
    case STRAIGHT_FLUSH:  str = "STRAIGHT_FLUSH";   break;
    case FOUR_OF_A_KIND:  str = "FOUR_OF_A_KIND";   break;
    case FULL_HOUSE:      str = "FULL_HOUSE";       break;
    case FLUSH:           str = "FLUSH";            break;
    case STRAIGHT:        str = "STRAIGHT";         break;
    case THREE_OF_A_KIND: str = "THREE_OF_A_KIND";  break;
    case TWO_PAIR:        str = "TWO_PAIR";         break;
    case ONE_PAIR:        str = "ONE_PAIR";         break;
    case HIGH_CARD:       str = "HIGH_CARD";        break;
    default:              str = "NOT_FOUND";        break;
  }
  printf("Rank: %s (%d)\n", str, rank);
}


int main(int argc, char *argv[]) {
  // printf("===== poker-eval =====\n");

  if (argc != 6) {
    printf("Usage: ./allfive card1 card2 card3 card4 card5\n");
    return -1;
  }

  if (!check_format(argv[1]) || !check_format(argv[2]) || !check_format(argv[3]) || !check_format(argv[4]) || !check_format(argv[5])) {
    printf("Invalid card format\n");
    return -1;
  }

  int deck[52];
  init_deck(deck);

  int r1 = extract_rank(argv[1][0]);
  int s1 = extract_suit(argv[1][1]);
  int r2 = extract_rank(argv[2][0]);
  int s2 = extract_suit(argv[2][1]);
  int r3 = extract_rank(argv[3][0]);
  int s3 = extract_suit(argv[3][1]);
  int r4 = extract_rank(argv[4][0]);
  int s4 = extract_suit(argv[4][1]);
  int r5 = extract_rank(argv[5][0]);
  int s5 = extract_suit(argv[5][1]);

  int c1_index = find_card(r1, s1, deck);
  int c2_index = find_card(r2, s2, deck);
  int c3_index = find_card(r3, s3, deck);
  int c4_index = find_card(r4, s4, deck);
  int c5_index = find_card(r5, s5, deck);

  if (c1_index == -1 || r1 == 99 || s1 == 99)
    printf("!!!!! c1_index is invalid !!!!!\n");
  if (c2_index == -1 || r2 == 99 || s2 == 99)
    printf("!!!!! c2_index is invalid !!!!!\n");
  if (c3_index == -1 || r3 == 99 || s3 == 99)
    printf("!!!!! c3_index is invalid !!!!!\n");
  if (c4_index == -1 || r4 == 99 || s4 == 99)
    printf("!!!!! c4_index is invalid !!!!!\n");
  if (c5_index == -1 || r5 == 99 || s5 == 99)
    printf("!!!!! c5_index is invalid !!!!!\n");

  int c1 = deck[c1_index];
  int c2 = deck[c2_index];
  int c3 = deck[c3_index];
  int c4 = deck[c4_index];
  int c5 = deck[c5_index];

  //printf("Hand: %d-%d %d-%d %d-%d %d-%d %d-%d\n", r1, s1, r2, s2, r3, s3, r4, s4, r5, s5);

  int rank = eval_5hand_fast(c1, c2, c3, c4, c5);

  //print_rank(rank);
  printf("%d", rank);
  return rank;
}